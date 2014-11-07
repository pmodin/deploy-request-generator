require_relative 'settings'
require_relative 'os'
require_relative 'git_info'
require_relative 'email_formatter'

# User interface and what opens the mailto link
class CLI
  def self.run
    cli = new(Settings.default_allowed, Settings.default_special, false)
    cli.check_if_windows
    cli.check_if_in_git_repo
    cli.check_if_in_master
    cli.special?
    cli.debug_output
    cli.open_mailto_link
  end

  def initialize(default_allowed, default_special, debug)
    @default_allowed = default_allowed
    @default_special = default_special
    @debug = debug
  end

  attr_reader :default_allowed, :default_special, :special, :debug

  def check_if_windows
    if OS.windows?
      puts 'Script does not support Windows.'
      exit 1
    end
  end

  def check_if_in_git_repo
    unless GitInfo.currently_in_git_repo?
      puts "Not in a git repository."
      exit 1
    end
  end

  def check_if_in_master
    if GitInfo.master?
      puts "You're currently in the 'master' branch."
      puts "You can't make a deploy request for this branch."
      exit 1
    end
  end

  def special?
    print "Does the deployer need any special instructions? #{yes_no_letters} "
    loop do
      answer = $stdin.gets.chomp.upcase

      if default_allowed && answer == ''
        @special = default_special
        break
      elsif answer == 'Y'
        @special = true
        break
      elsif answer == 'N'
        @special = false
        break
      else
        print "Please try again... #{yes_no_letters} "
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

  def open_mailto_link
    mailto_link = "mailto:#{email.to}?"\
      "subject=#{email.subject}"\
      "&body=#{format_newlines(email.body)}"

    `#{command} "#{mailto_link}"`
  end

  private

  def yes_no_letters
    if default_allowed
      if default_special
        '[Y/n]'
      else
        '[y/N]'
      end
    else
      '[Y/N]'
    end
  end

  def email
    @email ||= EmailFormatter.new(special)
  end

  def format_newlines(body)
    if OS.linux?
      body.gsub(/\n/, '%0D%0A')
    else
      body
    end
  end

  def command
    if OS.linux?
      'xdg-open'
    else
      'open'
    end
  end
end
