ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= 'info'
ENV['LOG_TAGS'] ||= '_untagged,-data,messaging,entity_projection,entity_store,ignored'

puts RUBY_DESCRIPTION

require 'pp'
require 'dotenv'
require 'pry-byebug'

require_relative 'init'
require_relative 'lib/bootstrapper'
require_relative 'lib/consumers/commands'

# bootstrap here

Dotenv.load!('.env') unless ENV['EVENTIDE_ENV'] == 'production'

Bootstrapper.run('account-component', __dir__) do
  # write_settings(overwrite: true)
  # binding.pry
  # Consumers::Commands.start('account:command', session: session)
  # Consumers::Commands::Transactions.start('accountTransaction', session: session)
  # Consumers::Events.start('account', session: session)

  Consumers::Commands.start('account:command')
end
