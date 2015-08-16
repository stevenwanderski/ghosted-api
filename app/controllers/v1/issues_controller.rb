class V1::IssuesController < ApplicationController
  before_filter :assign_repo, only: [:index]
  before_filter :check_for_loaded_issues, only: [:index]
  before_filter :verify_weights_format, only: [:weights]

  # TODO: protect against unauthorized resources (check the repo owner is caller)
  def index
    render json: @repo.issues.order(:weight)
  end

  def weights
    weights_params.each do |key, value|
      Issue.where(id: value[:id]).update_all(weight: value[:weight])
    end
    render json: { success: true }
  end

  private

  def assign_repo
    if params[:repo_id].nil?
      return render json: { errors: "Missing `repo_id` parameter" }, status: :unprocessable_entity
    end
    @repo = Repo.find(params[:repo_id])
  end

  def check_for_loaded_issues
    @repo.populate_issues(@user.access_token) unless @repo.issues_loaded?
  end

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
end