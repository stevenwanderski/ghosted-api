class MilestoneFetcher
  def initialize(repo, access_token)
    @repo = repo
    @access_token = access_token
  end

  def fetch
    Rails.logger.info("Populating milestones for repo: #{@repo.name} (#{@repo.id})")

    results = save_milestones
    @repo.update(milestones_loaded: true)

    Rails.logger.info("Successfully populated #{results[:ids].count} milestones for repo: #{@repo.name} (#{@repo.id})")

    results[:ids]
  end

  def save_milestones
    milestones_records_array = milestones.map.with_index do |milestone, index|
      [@repo.id, milestone.id, milestone.title, milestone.body, milestone.state, milestone.number, index]
    end
    Milestone.import(["repo_id", "milestone_id", "title", "body", "state", "number", "weight"], milestones_records_array)
  end

  def milestones
    client = Octokit::Client.new(access_token: @access_token)
    client.auto_paginate = true
    client.milestones(@repo.full_name)
  end
end