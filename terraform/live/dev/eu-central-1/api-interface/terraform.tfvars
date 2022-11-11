################################################################################
# Set global Tags
################################################################################

stage       = "integration"
region      = "eu-central-1"
project     = "performance-data"
application = "api-interface"
module      = "-"
owner       = "meinestadt"
purpose     = "setup the api interface infrastructure"
app_version = "1.0"


################################################################################
# Set AWS provider variables
################################################################################

aws_region = "eu-central-1"


################################################################################
# Env variables
################################################################################

rds_cluster_identifier     = "shared-postgres13-integration"
rds_secret_name            = "performance-data-rds-secret"
domain_cert_name           = "meinestadt.de"
rds_cluster_db_schema_name = "public"
rds_cluster_db_table_name  = "mlm_jobshop"
record_name                = "performance-data.integration.meinestadt.de"
aws_route53_zone_name      = "integration.meinestadt.de"
