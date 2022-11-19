# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch
  primary_coverage :branch
  minimum_coverage line: 95, branch: 95

  add_filter '/config'
  add_filter '/db/*'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_examples = false
  config.infer_spec_type_from_file_location!

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.before(:suite) do
    FactoryBot.lint traits: true
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('tmp/storage'))
  end

  config.after do
    Rails.cache.clear
  end

  config.before(:all) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    Sidekiq::Worker.clear_all
  end
end
