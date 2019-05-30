# This file contains various variables that affect the class itself
#

# The following variables should be defined via a seperate mechanism to avoid distribution
# For example the file terraform.tfvars

variable "azure_subscription_id" {
}

variable "azure_client_id" {
}

variable "azure_client_secret" {
}

variable "azure_tenant_id" {
}

variable "azure_avi_image_id" {
  default = "/subscriptions/77d6aa12-ef65-44f8-b9f5-07e7f7e8b48b/resourceGroups/avitraining/providers/Microsoft.Compute/images/controller1823"
}

variable "location" {
}

#variable "pkey" {
#}

variable "avi_default_password" {
}

variable "avi_admin_password" {
}

variable "avi_backup_admin_username" {
}

variable "avi_backup_admin_password" {
}

variable "student_count" {
  description = "The class size. Each student gets a controller"
  default     = 1
}

variable "lab_timezone" {
  description = "Lab Timezone: PST, EST, GMT or SGT"
}

variable "server_count" {
  description = "The class size. Students get a shared servers"
  default     = 4
}

variable "id" {
  description = "A prefix for the naming of the objects / instances"
  default     = "avi101"
}

variable "owner" {
  description = "Sets Owner tag appropriately"
  default     = "avi101_Training"
}
