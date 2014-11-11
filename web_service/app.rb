# encoding: utf-8
require 'yaml'
require 'active_support/all'

lib_dirs = %w(
  models/**
  payloads/**
  handlers/**
  dispatchers/**
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