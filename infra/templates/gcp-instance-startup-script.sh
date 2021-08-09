# Script to install Cloudflare Tunnel/SSH and Vault 
# The OS is updated
sudo apt update -y && sudo apt upgrade -yq
sudo apt install -y software-properties-common

### Create unix users for vault_ssh_users
%{ for user in vault_ssh_users }
sudo adduser --gecos "" --force-badname --disabled-password ${split("@", user)[0]}
usermod -aG sudo ${split("@", user)[0]}
%{ endfor }

# Allow running sudo without a password
cat <<EOF >> /etc/sudoers
%{ for user in vault_ssh_users }
${split("@", user)[0]} ALL = (ALL) NOPASSWD: ALL
%{ endfor }
EOF

# Create ca.pub
cat <<EOF > /etc/ssh/ca.pub
${vault_ssh_ca_key}
EOF

# Add ca.pub as TrustedUserCAKeys
cat <<EOF >> /etc/ssh/sshd_config
PubkeyAuthentication yes
TrustedUserCAKeys /etc/ssh/ca.pub
EOF

# Restart ssh to apply changes
sudo systemctl restart ssh

### Install and configure Cloudflare Tunnel

# The cloudflare package for this OS is retrieved 
wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
sudo dpkg -i cloudflared-stable-linux-amd64.deb

# Create /etc/cloudflared and fetch cloudflare tunnel credentials from GCP Secrets Manager
mkdir /etc/cloudflared || echo /etc/cloudflared already exists
gcloud secrets versions access latest --secret=cloudflare-tunnel-credentials > /etc/cloudflared/creds.json

# Create cloudflared config
cat <<EOF > /etc/cloudflared/config.yml
tunnel: ${cf_tunnel_id}
credentials-file: /etc/cloudflared/creds.json
logfile: /var/log/cloudflared.log
loglevel: info

warp-routing:
  enabled: true

ingress:
  - hostname: "*"
    path: "^/_healthcheck$"
    service: http_status:200
  - hostname: "${vault_hostname}"
    service: http://localhost:8200
  - hostname: "${vault_ssh_hostname}"
    service: ssh://localhost:22
  - service: http_status:404
EOF

# Install cloudflared as a systemd service
sudo cloudflared service install
sudo service cloudflared start

### Install and configure Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault

cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl
StartLimitIntervalSec=60
StartLimitBurst=3

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitInterval=60
StartLimitIntervalSec=60
StartLimitBurst=3
LimitNOFILE=65536
LimitMEMLOCK=infinity

[Install]
WantedBy=multi-user.target
EOF

# Full configuration options can be found at https://www.vaultproject.io/docs/configuration
cat <<EOF > /etc/vault.d/vault.hcl
ui = true
mlock = true

storage "gcs" {
  bucket = "${vault_gcs_bucket_name}"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true # tls is terminated local cloudflared tunnel
}

%{ if vault_kms_auto_unseal }
seal "gcpckms" {
  project     = "${gcp_project_id}"
  region      = "${vault_kms_keyring_location}"
  key_ring    = "${vault_kms_keyring_name}"
  crypto_key  = "${vault_kms_keyring_name}"
}
%{ endif }

EOF

sudo service vault start
