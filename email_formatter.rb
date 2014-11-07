require_relative 'git_info'

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
