require 'yaml'

# Provides methods returning the values found in settings.yml
module Settings
  class << self
    parsed_yaml = YAML.load_file(File.expand_path('../settings.yml', __FILE__))

    parsed_yaml.each do |key, value|
      define_method(key) { value }
    end
  rescue Errno::ENOENT
    $stderr.puts "'settings.yml' file not found."
    $stderr.puts "Copy and modify the 'settings.yml.sample' file."
    exit 1
  end
end
