class RepoFetcher
  def initialize(user)
    @user = user
  end

  def fetch
    client = Octokit::Client.new(access_token: @user.access_token)
    client.auto_paginate = true
    repos = client.repositories

    repo_ids = save_repos(repos)
    user_repo_ids = save_user_repos(repo_ids)

    { repo_ids: repo_ids, user_repos_id: user_repo_ids }
  end

  def save_repos(repos)
    Rails.logger.info("Populating repos for Github user: #{@user.username} (#{@user.id})")

    repo_models = repos.map do |repo|
      "(#{repo.id}, '#{repo.name}', '#{repo.full_name}', '#{Time.now}'::timestamp, '#{Time.now}'::timestamp)"
    end

    # SQL trick that removes duplicate records before the INSERT
    results = ActiveRecord::Base.connection.execute("
      INSERT INTO repos (repo_id, name, full_name, created_at, updated_at)
      SELECT DISTINCT ON (repo_id) r.repo_id, r.name, r.full_name, r.created_at, r.updated_at
      FROM (
        VALUES #{repo_models.join(',')}
      ) r (repo_id, name, full_name, created_at, updated_at)
      LEFT JOIN repos r2 USING (repo_id)
      WHERE r2.repo_id IS NULL
      RETURNING id;
    ");

    ids = results.values.flatten

    Rails.logger.info("Successfully populated #{ids.count} repos for Github user: #{@user.username} (#{@user.id})")

    ids
  end

  def save_user_repos(repo_ids)
    Rails.logger.info("Saving UserRepos for Github user: #{@user.username} (#{@user.id})")

    user_repo_records_array = repo_ids.map do |repo_id|
      [@user.id, repo_id]
    end
    user_repo_results = UserRepo.import(["user_id", "repo_id"], user_repo_records_array)
    ids = user_repo_results[:ids]

    Rails.logger.info("Successfully saved #{ids.count} UserRepos for Github user: #{@user.username} (#{@user.id})")

    ids
  end
end