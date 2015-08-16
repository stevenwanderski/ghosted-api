class Repo < ActiveRecord::Base
  has_many :user_repos, dependent: :destroy
  has_many :issues

  def populate_issues(access_token)
    logger.info("Populating issues for repo: #{self.name} (#{self.id})")
    self.update(issues_loaded: true) if save_issues(fetch_issues(access_token))
    logger.info("Successfully populated issues for repo: #{self.name} (#{self.id})")
  end

  def fetch_issues(access_token)
    client = Octokit::Client.new(access_token: access_token)
    client.auto_paginate = true
    client.issues(self.repo_id)
  end

  def save_issues(issues)
    issues_records_array = issues.map.with_index do |issue, index|
      [self.id, issue.id, issue.title, issue.body, issue.state, issue.number, index]
    end
    Issue.import(["repo_id", "issue_id", "title", "body", "state", "number", "weight"], issues_records_array)
    true
  end

  def reset_issues
    self.issues.destroy_all
    self.update(issues_loaded: false)
  end
end
