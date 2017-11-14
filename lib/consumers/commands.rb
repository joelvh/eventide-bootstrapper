require_relative '../handlers/commands'

module Consumers
  class Commands
    include Consumer::Postgres

    handler Handlers::Commands
  end
end
