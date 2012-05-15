require 'yaml'
begin
  env_yaml = YAML.load_file(File.dirname(__FILE__) + '/../config/env.yml')
  if env_hash = env_yaml[ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development']
    env_hash.each_pair do |k,v|
      ENV[k] = v.to_s
    end
  end
rescue StandardError => e
end

