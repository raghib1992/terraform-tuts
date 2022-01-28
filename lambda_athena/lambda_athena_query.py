import boto3
import json
import time

# Permisions
# Athena start query execution
# Athena Get query execution
# Athena Get query Result
# glue Get table

def lamdba_handler(event, context):
    client = boto3.client('athena')

    # Steup and perform query
    query = 'create database saas-ses-bounce-db;'
    # query= 'CREATE EXTERNAL TABLE saas_ses_bounce_table ( eventType string, mail struct<`timestamp`:string, source:string, sourceArn:string, sendingAccountId:string, messageId:string, destination:string, headersTruncated:boolean, headers:array<struct<name:string,value:string>>, commonHeaders:struct<`from`:array<string>,to:array<string>,messageId:string,subject:string>, tags:struct<ses_configurationset:string,ses_source_ip:string,ses_from_domain:string,ses_caller_identity:string> > ) ROW FORMAT SERDE \'org.openx.data.jsonserde.JsonSerDe\' WITH SERDEPROPERTIES ( "mapping.ses_configurationset"="ses:configuration-set", "mapping.ses_source_ip"="ses:source-ip", "mapping.ses_from_domain"="ses:from-domain", "mapping.ses_caller_identity"="ses:caller-identity" ) LOCATION \'s3://saas-ses-email-monitor/athena/\';'
    queryStart = client.start_query_execution(
        QueryString= query,
        QueryExecutionContext={
            'Database': 'saas_ses_bounce_db',
        },
        ResultConfiguration={
            'OutputLocation': 's3://raghib-ses-email-query-result/test/'
        },
    )

    queryID = queryStart['QueryExecutionId']
    time.sleep(15)
    print(queryID, type(queryID))

    queryResult = client.get_query_results(QueryExecutionId = queryID)
    print(queryResult)
    # # queryResult = client.get_query_results(QueryExecutionId = "0854c78b-a4a8-4486-9c6d-8929c2532ca3")
    # for row in queryResult['ResultSet']['Rows']:
    #     print(row)
