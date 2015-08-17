class RepoSerializer
  include JSONAPI::Serializer

  attribute :id
  attribute :repo_id
  attribute :name
  attribute :favorite
  attribute :issues_loaded
end
