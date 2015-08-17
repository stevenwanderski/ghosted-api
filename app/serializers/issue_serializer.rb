class IssueSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :repo_id
  attribute :issue_id
  attribute :title
  attribute :body
  attribute :state
  attribute :number
  attribute :weight
end
