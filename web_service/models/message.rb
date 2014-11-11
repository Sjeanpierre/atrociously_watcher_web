class Message
  def self.send(recipient_id, message)
    recipient = User.find(recipient_id) rescue nil
    if recipient
      Message.new(recipient, message).deliver
    end
  end

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