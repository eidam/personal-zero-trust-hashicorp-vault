locals {
  policies_folder = "${path.module}/policies"
  ignore_policies = [""]

  policies_list = setsubtract(fileset(local.policies_folder, "*.hcl"), local.ignore_policies)
}

resource "vault_policy" "folder" {
  for_each = local.policies_list

  name   = trimsuffix(each.key, ".hcl")
  policy = file("${local.policies_folder}/${each.key}")
}
