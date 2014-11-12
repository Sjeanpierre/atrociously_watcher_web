post '/receive_message' do
  MessageReceiver.delay.process(params)
  status 200
  body ''
end