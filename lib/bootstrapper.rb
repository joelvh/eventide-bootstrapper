require 'eventide/postgres'
require 'component_host'
require 'messaging/postgres'

require 'cgi'
require 'uri'
require 'json'

class Bootstrapper
  SETTINGS_PATH = 'settings/message_store_postgres.json'.freeze

  def self.run(component_name, project_root, &start_proc)
    bootstrapper = new(start_proc, component_name: component_name, project_root: project_root)

    ComponentHost.start(component_name) do |host|
      host.register(bootstrapper)
    end
  end

  def initialize(start_proc, component_name: nil, project_root: nil)
    @start_proc     = start_proc
    @component_name = component_name
    @root           = project_root
  end

  def call(*args, **keyword_args)
    write_settings
    instance_exec(*args, **keyword_args, &@start_proc)
  end

  def write_settings(hash = parse_database_url, overwrite: false)
    file_path = File.join(@root, SETTINGS_PATH)

    return if File.exist?(file_path) && !overwrite

    File.open(file_path, 'w') do |file|
      json = JSON.generate(hash)
      file.write(json)
    end
  end

  def session
    @session ||= build_session
  end

  def build_session(database_url = env_database_url)
    hash     = parse_database_url(database_url)
    settings = build_settings(hash)

    MessageStore::Postgres::Session.build(settings: settings)
  end

  def build_settings(hash)
    MessageStore::Postgres::Settings.build(prune(hash))
  end

  def parse_database_url(database_url = env_database_url)
    raise 'You must specify a database URI' unless database_url

    uri    = URI.parse(database_url)
    params = CGI.parse(uri.query.to_s)

    unless uri.scheme.to_s =~ /postgres/i
      raise "Database URL scheme must be 'postgres' -- #{uri.scheme.inspect} is not supported."
    end

    ipv4 = /\d+\.\d+\.\d+\.\d+/

    if uri.host =~ ipv4
      hostaddr = uri.host
    else
      hostname = uri.host
    end

    hash = {
      dbname:   uri.path.to_s.split('/')[1],
      host:     hostname,
      hostaddr: hostaddr,
      port:     uri.port,
      user:     uri.user,
      password: uri.password
    }

    MessageStore::Postgres::Settings.names.each do |name|
      next unless params.key?(name.to_s)

      value = params[name.to_s].first
      value = eval(value) if value =~ /^(true|false|[-]?\d+(\.\d+)?)$/

      hash[name] = value
    end

    prune(hash)
  end

  def env_database_url
    ENV['EVENTIDE_DATABASE_URL'] || ENV['DATABASE_URL']
  end

  def prune(hash)
    hash.select { |key, value| !value.nil? && MessageStore::Postgres::Settings.names.include?(key) }
  end
end
