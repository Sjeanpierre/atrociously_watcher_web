require 'aws-sdk'

Aws.config[:s3] = {
  :region => 'us-west-1',
  :access_key_id =>  ENV['AWS_KEY'],
  :secret_access_key =>  ENV['AWS_SECRET']
}
$s3 = Aws::S3.new
$sns = Aws::SNS::Client.new
$dynamo_db = Aws::DynamoDB::Client.new