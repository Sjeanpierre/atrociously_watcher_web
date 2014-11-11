class User < OpenStruct
  acts_as_dynamo_db dynamo_hash_key: :user_name 
  dynamo_attribute :user_name, :s
  dynamo_attribute :lat, :n
  dynamo_attribute :long, :n

  def self.create(user_name, lat = nil, long = nil)
    user = User.find(user_name) rescue nil
    if user
      user.lat = lat if lat.present?
      user.long = long if long.present?
      user.save if lat.present? || long.present?
    else
      user = User.new(user_name: user_name, lat: lat, long: long)
      user.save
    end
    user.send_welcome
  end

  def send_welcome
    if lat.present? && long.present?
      Message.delay.send(self.user_name, "Thank you for subscribing to Atrocity Watch.")
    else
      Message.delay.send(self.user_name, "Please let us know where you are currently located.")
    end
  end
end