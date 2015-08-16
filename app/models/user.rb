class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['USER_ENCRYPTION_KEY']

  has_many :repos, through: :user_repos
  has_many :user_repos, dependent: :destroy

  after_create :populate_repos, unless: :repos_loaded?

  def populate_repos
    logger.info("Populating repos for Github user: #{self.username} (#{self.id})")
    repo_ids = save_repos(fetch_repos)
    save_user_repos(repo_ids)
    self.update(repos_loaded: true)
    logger.info("Successfully populated repos for Github user: #{self.username} (#{self.id})")
  end

  def fetch_repos
    client = Octokit::Client.new(access_token: self.access_token)
    client.auto_paginate = true
    client.repositories
  end

  def save_repos(repos)
    repo_models = repos.map do |repo|
      "(#{repo.id}, '#{repo.name}', '#{Time.now}'::timestamp, '#{Time.now}'::timestamp)"
    end

    # Cool SQL trick that removes duplicate records before the INSERT
    ids = ActiveRecord::Base.connection.execute("
      INSERT INTO repos (repo_id, name, created_at, updated_at)
      SELECT DISTINCT ON (repo_id) r.repo_id, r.name, r.created_at, r.updated_at
      FROM (
        VALUES #{repo_models.join(',')}
      ) r (repo_id, name, created_at, updated_at)
      LEFT JOIN repos r2 USING (repo_id)
      WHERE r2.repo_id IS NULL
      RETURNING id;
    ");

    ids.values.flatten
  end

  def save_user_repos(repo_ids)
    user_repo_records_array = repo_ids.map do |repo_id|
      [self.id, repo_id]
    end
    results = UserRepo.import(["user_id", "repo_id"], user_repo_records_array)
    results[:ids]
  end
end
