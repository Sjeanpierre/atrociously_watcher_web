class User < OpenStruct
  acts_as_dynamo_db dynamo_hash_key: :user_name 
  dynamo_attribute :user_name, :s
  dynamo_attribute :lat, :n
  dynamo_attribute :long, :n

  def self.test(msg)
    puts msg
  end
end