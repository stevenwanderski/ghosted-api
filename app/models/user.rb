class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['USER_ENCRYPTION_KEY']

  has_many :repos, through: :user_repos
  has_many :issues, through: :repos
  has_many :milestones, through: :repos
  has_many :user_repos, dependent: :destroy

  def reset
    Milestone.where(id: self.milestones.pluck(:id)).destroy_all
    Issue.where(id: self.issues.pluck(:id)).destroy_all
    Repo.where(id: self.repos.pluck(:id)).destroy_all
    self.user_repos.destroy_all
    self.update(repos_loaded: false)
  end
end
