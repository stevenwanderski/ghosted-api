class Repo < ActiveRecord::Base
  has_many :user_repos, dependent: :destroy
end
