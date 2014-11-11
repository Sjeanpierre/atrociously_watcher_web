module ODynamoDb
  def self.included(base)
    base.class_variable_set(:@@dynamo_db_fields, Hash.new)
    base.class_variable_set(:@@dynamo_before_save, Array.new)
    base.class_variable_set(:@@dynamo_after_save, Array.new)
    base.extend(ClassMethods)
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

  module ClassMethods
    def dynamo_attribute(name, type)
      dynamo_db_fields = self.class_variable_get(:@@dynamo_db_fields)
      dynamo_db_fields[name] = type
    end

    def before_save(fn_name)
      self.class_variable_get(:@@dynamo_before_save) << fn_name
    end

    def after_save(fn_name)
      self.class_variable_get(:@@dynamo_after_save) << fn_name
    end

    def find(id)
      res = $dynamo_db.get_item(
        table_name: self.dynamo_table_name, 
        key: {self.dynamo_hash_key => id}
      )
      if res.item
        self.new(res.item)
      else
        raise 'Record not found'
      end
    end
  end

  def dynamo_attributes
    attrs = Hash.new
    dynamo_db_fields = self.class.class_variable_get(:@@dynamo_db_fields)
    dynamo_db_fields.each do |name, type|
      val = self.send(name)
      if type == :s
        val = val.to_s
      end
      attrs[name.to_s] = val
    end
    return attrs
  end

  def save
    self.class.class_variable_get(:@@dynamo_before_save).each do |fn|
      res = self.send(fn) rescue true
      unless res
        raise "#{fn} returned false"
      end
    end
    attrs = dynamo_attributes
    unless hash_key = attrs[self.class.dynamo_hash_key.to_s].present?
      raise 'No Key value to save with.'
    end
    $dynamo_db.put_item(
      table_name: self.class.dynamo_table_name,
      item: attrs
    )
    self.class.class_variable_get(:@@dynamo_after_save).each do |fn|
      res = self.send(fn)
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