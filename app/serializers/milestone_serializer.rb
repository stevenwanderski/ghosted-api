class MilestoneSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :repo_id
  attribute :milestone_id
  attribute :title
  attribute :body
  attribute :state
  attribute :number
  attribute :weight
end
