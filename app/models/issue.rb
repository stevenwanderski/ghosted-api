class Issue < ActiveRecord::Base
  belongs_to :repo
  belongs_to :milestone
end
