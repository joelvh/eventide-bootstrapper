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

Dotenv.load!('.env')

Bootstrapper.run('account-component') do
  binding.pry
  Consumers::Commands.start('account:command', session: session)
  #Consumers::Commands::Transactions.start('accountTransaction', session: session)
  #Consumers::Events.start('account', session: session)

end
