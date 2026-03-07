locals {
  db_engine_versions = {
    postgres = {
      engine_version       = "16.3"
      family               = "postgres16"
      major_engine_version = "16"
    }

    mysql = {
      engine_version       = "8.0.39"
      family               = "mysql8.0"
      major_engine_version = "8.0"
    }

    mariadb = {
      engine_version       = "10.11"
      family               = "mariadb10.11"
      major_engine_version = "10.11"
    }
  }

  # Hardcoded EKS node SG IDs used by all RDS apps in this env/country.
  eks_node_security_group_ids = ["sg-REPLACE_ME"]
}
