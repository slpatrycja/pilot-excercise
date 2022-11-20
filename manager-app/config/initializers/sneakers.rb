require 'sneakers'
require 'sneakers/handlers/maxretry'

Sneakers.configure(
  connection: Bunny.new(
    hostname: ENV.fetch('RABBITMQ_HOST'),
    user: ENV.fetch('RABBITMQ_USER'),
    password: ENV.fetch('RABBITMQ_PASSWORD')
  ),
  exchange: 'payment_requests',
  exchange_type: :direct,
  runner_config_file: nil,
  metric: nil,
  workers: 1,
  log: STDOUT,
  pid_path: 'sneakers.pid',
  timeout_job_after: 5.minutes,
  env: ENV['RAILS_ENV'],
  durable: true,
  ack: true,
  heartbeat: 2,
  handler: Sneakers::Handlers::Maxretry
)

Sneakers.logger = Rails.logger
Sneakers.logger.level = Logger::WARN
