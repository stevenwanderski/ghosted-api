class V1::IssuesController < ApplicationController
  before_filter :assign_milestone, only: [:create]
  before_filter :convert_jsonapi_params, only: [:create]
  before_filter :verify_weights_format, only: [:weights]

  def weights
    weights_params.each do |key, value|
      Issue.where(id: value[:id]).update_all(weight: value[:weight])
    end
    render json: { success: true }
  end

  def create
    client = Octokit::Client.new(access_token: @user.access_token)
    result = client.create_issue(@milestone.repo.full_name, issue_params[:title], nil, milestone: @milestone.number)
    issue = Issue.new(
      repo_id: @milestone.repo.id,
      issue_id: result.id,
      milestone_id: @milestone.id,
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

  def weights_params
    params.require(:weights)
  end

  def verify_weights_format
    weights_params.each do |key, value|
      if value[:id].nil? || value[:weight].nil?
        return render json: { errors: "The `weight` param must contain an array objects in the following format: { id: [string], weight: [integer] }"}
      end
    end
  end

  def convert_jsonapi_params
    params[:issue] = params[:data][:attributes]
  end

  def issue_params
    params.require(:issue).permit(:title)
  end

  def assign_milestone
    @milestone = Milestone.find(params[:milestone_id])
  end
end