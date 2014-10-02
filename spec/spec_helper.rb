require 'bundler/setup'
require 'rspec'
Dir[File.expand_path('../support/**/*', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run_excluding :broken => true
  config.filter_run_excluding :skip => true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
