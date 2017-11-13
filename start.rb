ENV['CONSOLE_DEVICE'] ||= 'stdout'
ENV['LOG_LEVEL'] ||= 'info'
ENV['LOG_TAGS'] ||= '_untagged,-data,messaging,entity_projection,entity_store,ignored'

puts RUBY_DESCRIPTION

require_relative 'init.rb'
require_relative './lib/bootstrapper.rb'

require 'pp'

# bootstrap here

Bootstrapper.run('account-component') do

  # configure

  database_url = ENV['EVENTIDE_DATABASE_URL'] || ENV['DATABASE_URL']

  if database_url
    session = Bootstrapper.session_from_database_url(database_url)
  end

  # start

  Consumers::Commands.start('account:command', session: session)
  Consumers::Commands::Transactions.start('accountTransaction', session: session)
  Consumers::Events.start('account', session: session)

end
