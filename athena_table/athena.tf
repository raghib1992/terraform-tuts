data "aws_s3_bucket" "saas_bucket_query_result" {
  bucket = "raghib-ses-email-query-result"
  # bucket = "saas-ses-email-query-result-prod"
}

resource "aws_athena_database" "saas_athena_new" {
  name   = "raghib_bounce_db"
  bucket = data.aws_s3_bucket.saas_bucket_query_result.id
}

# resource "aws_athena_workgroup" "example" {
#   name = "ses-mail-bounce-wg"
# }

variable "statement" {
  default = <<EOF
  CREATE EXTERNAL TABLE saas_ses_bounce_table ( eventType string, mail struct<`timestamp`:string, source:string, sourceArn:string, sendingAccountId:string, messageId:string, destination:string, headersTruncated:boolean, headers:array<struct<name:string,value:string>>, commonHeaders:struct<`from`:array<string>,to:array<string>,messageId:string,subject:string>, tags:struct<ses_configurationset:string,ses_source_ip:string,ses_from_domain:string,ses_caller_identity:string> > ) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' WITH SERDEPROPERTIES ( "mapping.ses_configurationset"="ses:configuration-set", "mapping.ses_source_ip"="ses:source-ip", "mapping.ses_from_domain"="ses:from-domain", "mapping.ses_caller_identity"="ses:caller-identity" ) LOCATION 's3://saas-ses-email-monitor/athena/';
  EOF
}

resource "aws_athena_named_query" "raghib_bounce_table" {
  name      = "raghib-bounce-new"
  database  = aws_athena_database.saas_athena_new.name
  # database = "saas_ses_bounce_db"
  # workgroup = aws_athena_workgroup.example.id
  # workgroup = "ses-mail-bounce-wg"
  query     = var.statement
}

output "queryResult" {
  value = aws_athena_named_query.raghib_bounce_table
}
# CREATE EXTERNAL TABLE saas_ses_bounce_table ( eventType string, mail struct<`timestamp`:string, source:string, sourceArn:string, sendingAccountId:string, messageId:string, destination:string, headersTruncated:boolean, headers:array<struct<name:string,value:string>>, commonHeaders:struct<`from`:array<string>,to:array<string>,messageId:string,subject:string>, tags:struct<ses_configurationset:string,ses_source_ip:string,ses_from_domain:string,ses_caller_identity:string> > ) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' WITH SERDEPROPERTIES ( "mapping.ses_configurationset"="ses:configuration-set", "mapping.ses_source_ip"="ses:source-ip", "mapping.ses_from_domain"="ses:from-domain", "mapping.ses_caller_identity"="ses:caller-identity" ) LOCATION 's3://saas-ses-email-monitor/athena/';
