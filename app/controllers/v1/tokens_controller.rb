class V1::TokensController < ApplicationController
  skip_before_filter :authorize_user

  def create
    token = app_client.exchange_code_for_token(params[:code])
    user_data = user_client(token).user

    user = User.find_by(github_id: user_data.id)
    user_attrs = {
      username: user_data.login,
      avatar: user_data.avatar_url,
      meta: user_data.attrs,
      access_token: token.access_token
    }

    if user
      user.update(user_attrs)
    else
      user = User.create(user_attrs.merge(github_id: user_data.id))
    end

    render json: {
      user_id: user.id,
      access_token: token.access_token,
      username: user_data.login,
      avatar_url: user_data.avatar_url
    }
  rescue Octokit::Unauthorized => e
    render json: { errors: e.message }, status: :unauthorized
  end

  private

  def app_client
    Octokit::Client.new(
      client_id: ENV['GITHUB_CLIENT_ID'],
      client_secret: ENV['GITHUB_CLIENT_SECRET']
    )
  end

  def user_client(token)
    Octokit::Client.new(access_token: token.access_token)
  end
end
