class User < ActiveRecord::Base
  attr_encrypted :access_token, key: ENV['USER_ENCRYPTION_KEY']

  has_many :repos, through: :user_repos
  has_many :issues, through: :repos
  has_many :milestones, through: :repos
  has_many :user_repos, dependent: :destroy

  def reset
    Milestone.delete_all(id: self.milestones.pluck(:id))
    Issue.delete_all(id: self.issues.pluck(:id))
    Repo.delete_all(id: self.repos.pluck(:id))
    UserRepo.delete_all(user_id: self.id)
    self.update(repos_loaded: false)
  end
end
