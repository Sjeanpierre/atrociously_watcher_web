class MessageReceiver
  def initialize(message)
    @message = message
  end

  def process
    puts @message[:Body]
    puts @message[:From]
    puts @message[:FromCity]
  end
end