class User < OpenStruct
  acts_as_dynamo_db(dynamo_hash_key: :user_name)
  dynamo_attribute(:user_name, :s)
end