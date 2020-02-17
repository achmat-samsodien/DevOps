variable "key_name" {
  default =  "bastion_key"
}

variable "key_pair" {
  // for example purposes only, should go in terrafrom.tfvars which should be gitignored
  default = "ssh-rsa AAAAB3Nz achmatsamsodien@machine"
}