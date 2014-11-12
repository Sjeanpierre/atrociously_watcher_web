post '/api/subscribe' do
  if params[:token] != ENV['AWW_API_TOKEN']
    status 401
    body ''
    return
  end
  User.create(params[:phone_number], params[:lat], params[:long])
  status 200
  body 'OK'
end