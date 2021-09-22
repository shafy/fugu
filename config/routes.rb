Rails.application.routes.draw do
  devise_for :users
  root to: "projects#index"

  resources :projects, only: [:index, :new, :create]

  get "projects/:slug", to: "projects#show", as: :project

  namespace :api do
    namespace :v1 do
     resources :events, only: [:create]
    end
  end
end
