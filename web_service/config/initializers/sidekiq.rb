require 'sidekiq'
require 'redis'
require 'redis-namespace'
$rack_env = ENV['RACK_ENV'] || 'development'
$redis_config = YAML.load_file("#{$app_dir}/config/redis.yml")[$rack_env]

redis_conn = proc {
  Redis::Namespace.new('aww_sidekiq', redis: Redis.new(host: $redis_config['sidekiq']['host'], port: $redis_config['sidekiq']['port'], db: 2, driver: :hiredis))
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 60, &redis_conn)
end