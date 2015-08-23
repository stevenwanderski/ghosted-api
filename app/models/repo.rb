class Repo < ActiveRecord::Base
  has_many :user_repos, dependent: :destroy
  has_many :issues, dependent: :destroy
  has_many :milestones, dependent: :destroy

  def reset
    self.issues.destroy_all
    self.milestones.destroy_all
    self.update(issues_loaded: false, milestones_loaded: false)
  end
end
