module ODynamoDb
  def self.configure_options(klass, options = {})
    [:dynamo_table_name].each do |name|
      klass.class_eval %Q{
        def self.#{name.to_s}=(v)
          @@#{name.to_s} = v
        end
        
        def self.#{name.to_s}
          return @@#{name.to_s}
        end
      }
      if value = options[name]
        klass.send("#{name}=", value)
      end
    end
  end
end

if !defined?(OpenStruct)
  require 'ostruct'
end

class OpenStruct
  def self.acts_as_dynamo_db(options = {})
    self.send(:include, ODynamoDb)
    if !options[:dynamo_table_name]
      options[:dynamo_table_name] = self.to_s.pluralize.underscore
    end
    ODynamoDb.configure_options(self, options)
  end
end