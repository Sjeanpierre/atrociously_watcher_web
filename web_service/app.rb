# encoding: utf-8
require 'yaml'
require 'active_support/all'
$app_dir = File.dirname(__FILE__)
$redis_config = YAML.load_file("#{File.dirname(__FILE__)}/config/redis.yml")[$rack_env]
lib_dirs = %w(
  models/**
  workers/**
)
lib_dirs.each do |dir|
  Dir["#{$app_dir}/#{dir}/*.rb"].each do |file|
    match = file.match(/\/([^\/.]+)\.rb$/)
    if match
      file_name = match[1]
      autoload(file_name.camelize.to_sym, file)
    end
  end
end
# Load up any initializers we have.
Dir["#{$app_dir}/config/initializers/**/*.rb"].each do |file|
  match = file.match(/\/([^\/.]+)\.rb$/)
  if match
    file_name = match[1]
    require file
  end
end

# Load our psudo controllers
Dir["#{File.dirname(__FILE__)}/controllers/**/*.rb"].each do |file|
  require file
end