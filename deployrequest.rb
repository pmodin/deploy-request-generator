#!/usr/bin/env ruby
# encoding: utf-8

# Creates a deploy-request e-mail for the current branch

# Handles the various git-interactions
module GitInfo
  class << self
    def currently_in_git_repo?
      # TODO: use popen3 to check the exit code of this command:
      # git rev-parse --git-dir
    end

    def branch_name
      @branch_name ||= `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def commit_log
      @commit_log ||= `git log --reverse origin/master.. --format='%h %s'`.chomp
    end

    def commit_count
      commit_log.lines.count
    end

    def shortstat
      `git diff --shortstat origin/master...`.strip
    end

    def redmine_urls
      redmine_refs.map do |ref|
        "https://issue.tracker.com/issues/#{ref}"
      end.join("\n")
    end

    private

    def redmine_refs
      merge_base = `git merge-base HEAD master`.chomp
      `git log #{merge_base}..HEAD --format='%b' | grep refs`.
        gsub('refs #', '').chomp.split(/\s+/).uniq.sort_by { |ref| ref.to_i }
    end
  end
end

# Contains the various snippets of text generated for the mail
class EmailFormatter
  def initialize(special)
    @special = special
  end

  attr_reader :special

  def to
    'Deploy officer <deploy@example.com>'
  end

  def subject
    "Deploy request #{special ? '[SPECIAL]' : '[no special]'} for "\
      "\"#{GitInfo.branch_name}\""
  end

  def body
    <<BODY
# Branch
#{GitInfo.branch_name}
#{special ? "\n# Deploy instructions\n1. \n" : ''}
# Commits
#{GitInfo.commit_log}

# Shortstat
#{GitInfo.shortstat}

# Referenced issues
#{GitInfo.redmine_urls}
BODY
  end
end

# User interface and what opens the mailto link
class CLI
  def self.run
    cli = new(true, false)
    cli.special?
    cli.debug_output
    cli.open
  end

  def initialize(default_allowed, debug)
    # TODO: use "default_allowed" to allow user to just press enter on
    # special-prompt
    @default_allowed = default_allowed
    @debug = debug
  end

  attr_reader :special, :debug

  def special?
    puts 'Does the deployer need any special instructions? [Y/N]'
    loop do
      answer = $stdin.gets.chomp
      case answer.upcase
      when 'Y'
        @special = true
        break
      when 'N'
        @special = false
        break
      else
        puts 'Please try again... [Y/N]'
      end
    end
  end

  def debug_output
    return unless debug

    puts 'TO:'
    puts '---'
    puts email.to
    puts 'SUBJECT:'
    puts '--------'
    puts email.subject
    puts
    puts 'BODY:'
    puts '-----'
    puts email.body
  end

  def open
    command = 'xdg-open'
    mailto_link = "mailto:#{email.to}?subject=#{email.subject}"\
      "&body=#{email.body.gsub(/\n/, '%0D%0A')}"
    `#{command} "#{mailto_link}"`
  end

  private

  def email
    @email ||= EmailFormatter.new(special)
  end
end

CLI.run
