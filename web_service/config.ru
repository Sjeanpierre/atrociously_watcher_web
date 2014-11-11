# encoding: utf-8
$rack_env = ENV['RACK_ENV'] || 'development'
RACK_ENV = $rack_env #for new relic
require 'rubygems'
require 'bundler'
require 'yaml'
Bundler.require(:default, $rack_env.to_sym)

require "#{File.dirname(__FILE__)}/app"

use Rack::ShowExceptions

run Sinatra::Application
