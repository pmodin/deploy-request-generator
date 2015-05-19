require_relative 'git_info'

# Contains the various snippets of text generated for the mail
class EmailFormatter
  def initialize(special, target_branch_is_master)
    @special = special
    @target_branch_is_master = target_branch_is_master
  end

  attr_reader :special, :target_branch_is_master

  def to
    Settings.email_to
  end

  def subject
    "Deploy request #{special ? '[SPECIAL]' : '[no special]'} for "\
      "\"#{GitInfo.branch_name}\""
  end

  def body
    <<BODY
# Branch
#{GitInfo.branch_name}
#{!target_branch_is_master ? "\n# Target branch\n" : ''}
#{special ? "\n# Deploy instructions\n1. \n" : ''}
# Commits
#{GitInfo.commit_log}

# Shortstat
#{GitInfo.shortstat}

# Referenced issues
#{GitInfo.issue_urls}
BODY
  end
end
