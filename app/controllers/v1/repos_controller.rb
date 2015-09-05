class V1::ReposController < ApplicationController
  before_filter :assign_repo, only: [:show, :update, :issues, :milestones, :create_issue]
  before_filter :convert_json_api_params, only: [:update]
  before_filter :convert_json_api_issue_params, only: [:create_issue]
  before_filter :check_for_loaded_milestones, only: [:milestones, :issues]
  before_filter :check_for_loaded_issues, only: [:milestones, :issues]

  def index
    repos = @user.repos.order("LOWER(name) ASC")
    if(params[:favorite])
      repos = repos.where(favorite: params[:favorite])
    end
    render json: JSONAPI::Serializer.serialize(repos, is_collection: true)
  end

  # TODO: protect against unauthorized resources (check the repo owner is caller)
  def update
    if @repo.update(repo_params)
      render json: JSONAPI::Serializer.serialize(@repo), status: :ok
    else
      render json: { errors: repo.errors }, status: :unprocessable_entity
    end
  end

  # TODO: protect against unauthorized resources (check the repo owner is caller)
  def show
    render json: JSONAPI::Serializer.serialize(@repo)
  end

  def issues
    render json: IssueSerializer.serialize(@repo.issues.order(:weight), is_collection: true)
  end

  def milestones
    render json: MilestoneSerializer.serialize(@repo.milestones, is_collection: true)
  end

  def create_issue
    client = Octokit::Client.new(access_token: @user.access_token)
    result = client.create_issue(@repo.full_name, issue_params[:title], nil)
    issue = Issue.new(
      repo_id: @repo.id,
      issue_id: result.id,
      title: result.title,
      state: result.state,
      number: result.number,
      weight: 0
    )
    if issue.save
      render json: IssueSerializer.serialize(issue)
    else
      render json: { errors: issue.errors }, status: :unprocessable_entity
    end
  end

  private

  def repo_params
    params.require(:repo).permit(:favorite)
  end

  def issue_params
    params.require(:issue).permit(:title, :state)
  end

  def assign_repo
    @repo = Repo.find(params[:id])
  end

  def convert_json_api_params
    data = params.delete(:data)
    data_params = {}
    data[:attributes].each do |key, value|
      data_params[key.underscore] = value
    end
    params[:repo] = data_params
  end

  def convert_json_api_issue_params
    params[:issue] = params[:data][:attributes]
  end

  def check_for_loaded_milestones
    MilestoneFetcher.new(@repo, @user.access_token).fetch unless @repo.milestones_loaded?
  end

  def check_for_loaded_issues
    IssueFetcher.new(@repo, @user.access_token).fetch unless @repo.issues_loaded?
  end
end