Rails.application.routes.draw do
  namespace :v1 do
    post "tokens", to: "tokens#create"
    put "issues/weights"

    resources :repos, only: [:index, :update, :show] do
      member do
        get "issues"
        get "milestones"
      end
    end

    resources :milestones, only: [:show] do
      member do
        get "issues"
      end
    end
  end
end
