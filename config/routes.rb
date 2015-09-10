Rails.application.routes.draw do
  namespace :v1 do
    post "tokens", to: "tokens#create"

    resources :repos, only: [:index, :update, :show] do
      resources :milestones, only: [:create]
      member do
        get "issues"
        post "issues", action: "create_issue"
        get "milestones"
      end
    end

    resources :issues, only: [:show, :update, :create] do
      collection do
        put "weights"
      end
    end

    resources :milestones, only: [:show, :update] do
      member do
        get "issues"
        post "issues", action: "create_issue"
      end
    end
  end
end
