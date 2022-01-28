ref:
https://docs.aws.amazon.com/athena/latest/ug/parsing-JSON.html
https://aws.amazon.com/blogs/big-data/create-tables-in-amazon-athena-from-nested-json-and-mappings-using-jsonserde/

# CLI command to create aws athena db
aws athena start-query-execution \
    --query-string "create database if not exists newdb" \
    --result-configuration OutputLocation="s3://saas-ses-email-monitor/athena/"


# CLI command to create aws athena table
aws athena start-query-execution \
    --query-string "CREATE EXTERNAL TABLE saas_ses_bounce_table ( eventType string, mail struct<`timestamp`:string, source:string, sourceArn:string, sendingAccountId:string, messageId:string, destination:string, headersTruncated:boolean, headers:array<struct<name:string,value:string>>, commonHeaders:struct<`from`:array<string>,to:array<string>,messageId:string,subject:string>, tags:struct<ses_configurationset:string,ses_source_ip:string,ses_from_domain:string,ses_caller_identity:string> > ) ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' WITH SERDEPROPERTIES ( "mapping.ses_configurationset"="ses:configuration-set", "mapping.ses_source_ip"="ses:source-ip", "mapping.ses_from_domain"="ses:from-domain", "mapping.ses_caller_identity"="ses:caller-identity" ) LOCATION 's3://saas-ses-email-monitor/athena/'" \
    --query-execution-context Database="newdb"
    --result-configuration OutputLocation="s3://saas-ses-email-monitor/athena/"

aws athena start-query-execution --query-string "CREATE EXTERNAL TABLE sesblog (\
  eventType string,\
  mail struct<`timestamp`:string,\
              source:string,\
              sourceArn:string,\
              sendingAccountId:string,\
              messageId:string,\
              destination:string,\
              headersTruncated:boolean,\
              headers:array<struct<name:string,value:string>>,\
              commonHeaders:struct<`from`:array<string>,to:array<string>,messageId:string,subject:string>\
              >\
  )\
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'\
LOCATION 's3://saas-ses-email-monitor/athena/" --query-execution-context Database="newdb" --result-configuration OutputLocation="s3://saas-ses-email-monitor/athena/"\
    --query-execution-context Database="newdb"\
    --result-configuration OutputLocation="s3://saas-ses-email-monitor/athena/"