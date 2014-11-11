class Message
  def initialize(recipient, message)
    @recipient = recipient
    @message = message
  end

  def deliver
    twilio_client = $twilio
    twilio_client.messages.create(:from => $twilio_phone,
    :to => @recipient.user_name,
    :body => @message)
  end
end