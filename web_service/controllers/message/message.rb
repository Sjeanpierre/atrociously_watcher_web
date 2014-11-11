post '/receive_message' do
  MessageReceiver.new(params).process
  status 200
  body ''
end