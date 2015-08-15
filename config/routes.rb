Rails.application.routes.draw do
  namespace :v1 do
    post "tokens", to: "tokens#create"
    resources :repos
  end
end
