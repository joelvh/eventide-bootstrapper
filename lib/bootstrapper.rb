require 'component_host'

require 'cgi'
require 'uri'

module Bootstrapper
  extend self

  def run(component_name, &start_proc)
    ComponentHost.start(component_name) do |host|
      host.register(start_proc)
    end
  end

  def session_from_database_url(database_url)
    settings = settings_from_database_url(database_url)
    MessageStore::Postgres::Session.build(settings: settings)
  end

  def settings_from_database_url(database_url)
    unless database_url
      raise "You must specify a database URI"
    end

    uri    = URI.parse(database_url)
    params = CGI.parse(uri.query.to_s)

    unless uri.scheme.to_s =~ /postgres/i
      raise "Database URL scheme must be 'postgres' -- #{uri.scheme.inspect} is not supported."
    end

    if uri.host =~ /\d+\.\d+\.\d+\.\d+/
      hostaddr = uri.host
    else
      hostname = uri.host
    end

    config = {
      dbname:          uri.path.to_s.split('/')[1],
      host:            hostname,
      hostaddr:        hostaddr,
      port:            uri.port,
      user:            uri.user,
      password:        uri.password,
      connect_timeout: params['timeout'],
      options:         params['options'],
      sslmode:         params['sslmode'],
      krbsrvname:      params['krbsrvname'],
      gsslib:          params['gsslib'],
      service:         params['service']
    }

    MessageStore::Postgres::Settings.build(config)
  end
end
