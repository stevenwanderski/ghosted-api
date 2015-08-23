Rails.application.routes.draw do
  namespace :v1 do
    post "tokens", to: "tokens#create"
    put "issues/weights"

    resources :repos, only: [:index, :update, :show] do
      resources :milestones, only: [:create]
      member do
        get "issues"
        get "milestones"
        # post "milestones", action: "create_milestone"
      end
    end

    resources :milestones, only: [:show] do
      resources :issues, only: [:create]
      member do
        get "issues"
      end
    end
  end
end
