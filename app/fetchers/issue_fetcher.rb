class IssueFetcher
  def initialize(repo, access_token)
    @repo = repo
    @access_token = access_token
  end

  def fetch
    Rails.logger.info("Populating issues for repo: #{@repo.name} (#{@repo.id})")

    results = save_issues
    @repo.update(issues_loaded: true)

    Rails.logger.info("Successfully populated #{results[:ids].count} issues for repo: #{@repo.name} (#{@repo.id})")

    results[:ids]
  end

  def save_issues
    issues_records_array = issues.map.with_index do |issue, index|
      milestone_id = nil
      if issue.milestone? && milestone = Milestone.find_by(milestone_id: issue.milestone.id)
        milestone_id = milestone.id
      end
      [@repo.id, issue.id, milestone_id, issue.title, issue.body, issue.state, issue.number, index]
    end
    Issue.import(["repo_id", "issue_id", "milestone_id", "title", "body", "state", "number", "weight"], issues_records_array)
  end

  def issues
    client = Octokit::Client.new(access_token: @access_token)
    client.auto_paginate = true
    client.issues(@repo.repo_id)
  end
end