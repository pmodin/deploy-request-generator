#!/usr/bin/env ruby
# encoding: utf-8

# Creates a deploy-request e-mail for the current branch

require_relative 'cli'
require 'yaml'

begin
  ENV.update(YAML.load_file(File.expand_path('../settings.yml', __FILE__)))
rescue Errno::ENOENT
  puts "'settings.yml' file not found."
  puts "Copy and modify the 'settings.yml.sample' file."
  exit 1
end

CLI.run
