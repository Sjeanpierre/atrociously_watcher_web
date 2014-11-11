require 'aws-sdk'

Aws.config[:s3] = {
  :region => ENV['AWW_REGION'],
  :access_key_id =>  ENV['AWW_AWS_KEY'],
  :secret_access_key =>  ENV['AWW_AWS_SECRET']
}
$s3 = Aws::S3.new
$sns = Aws::SNS::Client.new
$dynamo_db = Aws::DynamoDB::Client.new
