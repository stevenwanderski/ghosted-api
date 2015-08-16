Rails.application.routes.draw do
  namespace :v1 do
    post "tokens", to: "tokens#create"
    resources :repos, only: [:index, :update, :show]
    resources :issues, only: [:index] do
      collection do
        put "weights"
      end
    end
  end
end
