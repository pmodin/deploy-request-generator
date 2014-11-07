# Handles the various git-interactions
module GitInfo
  require 'open3'

  class << self
    def currently_in_git_repo?
      _, _, _, wait_thread = Open3.popen3('git rev-parse --git-dir')
      exit_code = wait_thread.value.exitstatus

      exit_code == 0
    end

    def master?
      branch_name == 'master'
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
        gsub('refs #', '').chomp.split(/\s /).uniq.sort_by { |ref| ref.to_i }
    end
  end
end
