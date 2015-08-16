class V1::ReposController < ApplicationController
  def index
    repos = @user.repos.order("LOWER(name) ASC")
    if(params[:favorite])
      repos = repos.where(favorite: params[:favorite])
    end
    render json: repos
  end

  # TODO: protect against unauthorized resources (check the repo owner is caller)
  def update
    repo = Repo.find(params[:id])
    if repo.update(repo_params)
      render json: repo, status: :ok
    else
      render json: { errors: repo.errors }, status: :unprocessable_entity
    end
  end

  # TODO: protect against unauthorized resources (check the repo owner is caller)
  def show
    repo = Repo.find(params[:id])
    render json: repo
  end

  private

  def repo_params
    params.require(:repo).permit(:favorite)
  end
end