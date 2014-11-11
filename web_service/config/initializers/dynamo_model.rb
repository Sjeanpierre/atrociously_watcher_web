module ODynamoDb
  def self.included(base)
    base.class_variable_set(:@@dynamo_db_fields, Hash.new)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def dynamo_attribute(name, type)
      dynamo_db_fields = self.class_variable_get(:@@dynamo_db_fields)
      dynamo_db_fields[name] = type
    end
  end

  def dynamo_attributes
    attrs = Hash.new
    dynamo_db_fields = self.class.class_variable_get(:@@dynamo_db_fields)
    dynamo_db_fields.each do |name, type|
      val = Hash.new
      val[type] = self.send(name)
      attrs[name] = val
    end
    return attrs
  end

  def self.configure_options(klass, options = {})
    [:dynamo_table_name, :dynamo_hash_key].each do |name|
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