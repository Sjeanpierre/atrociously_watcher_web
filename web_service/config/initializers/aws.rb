require 'aws-sdk-core'

opts = {
  :region => ENV['AWW_REGION'],
  :access_key_id =>  ENV['AWW_AWS_KEY'],
  :secret_access_key =>  ENV['AWW_AWS_SECRET']
}


$dynamo_db = Aws::DynamoDB::Client.new(opts)
