#!/usr/bin/env ruby
# encoding: utf-8

# Creates a deploy-request e-mail for the current branch

require_relative 'cli'
require 'yaml'

ENV.update(YAML.load_file(File.expand_path('../settings.yml', __FILE__)))

CLI.run
