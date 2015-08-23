class Milestone < ActiveRecord::Base
  belongs_to :repo
  has_many :issues
end
