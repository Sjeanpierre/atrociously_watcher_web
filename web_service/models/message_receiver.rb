class MessageReceiver
  def initialize(message)
    @message = message
  end

  def self.process(message)
    new(message).process
  end

  def process
    user = User.find(@message[:From]) rescue nil
    if user
      user.receive_message(@message)
    else
      User.create(@message[:From])
    end
  end
end