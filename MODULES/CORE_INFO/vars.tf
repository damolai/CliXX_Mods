variable "required_tags" {
    description = "Tags required to be specified on all resources"
    type = object({
      environment = string
      OwnerEmail = string
      Session = string
      Subsystem = string
      Backup = string
      Organization = string
    })
    validation {
      condition = var.required_tags.environment != "" && var.required_tags.environment == lower(var.required_tags.environment) && contains(["dev","test","prod","uat"], var.required_tags.environment)
      error_message = "The environment tag must be a non-empty value, must be lowercase, and must be one of -dev,test,prod,uat."
    }
    validation {
      condition = var.required_tags.OwnerEmail != "" && var.required_tags.OwnerEmail == lower(var.required_tags.OwnerEmail)
      error_message = "The OwnerEmail tag must be a non-empty value and must be lowercase."
    }
    validation {
      condition = var.required_tags.Session != "" && var.required_tags.Session == lower(var.required_tags.Session)
      error_message = "The Session tag must be a non-empty value and must be lowercase."
    }
    validation {
      condition = var.required_tags.Subsystem != ""
      error_message = "The Subsystem tag must be a non-empty value."
    }
    validation {
      condition = var.required_tags.Backup != "" && (var.required_tags.Backup == "Yes" || var.required_tags.Backup == "No")
      error_message = "The Backup tag must be a non-empty value and must be one of -Yes or No."
    }
    validation {
      condition = var.required_tags.Organization != ""
      error_message = "The Organization tag must be a non-empty value."
    }
}