require 'twilio-ruby'

Twilio.configure do |config|
  config.account_sid = ENV['AWW_TWILIO_SID']
  config.auth_token = ENV['AWW_TWILIO_AUTH_TOKEN']
end

$twilio = Twilio::REST::Client.new
$twilio_phone = '4043414819'