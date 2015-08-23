class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['USER_ENCRYPTION_KEY']

  has_many :repos, through: :user_repos
  has_many :issues, through: :user_repos
  has_many :milestones, through: :user_repos
  has_many :user_repos, dependent: :destroy

  def reset
    self.milestones.destroy_all
    self.issues.destroy_all
    self.repos.destroy_all
    self.user_repos.destroy_all
    self.update(repos_loaded: false)
  end
end
