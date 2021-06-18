Rails.application.routes.draw do
  resources :projects

  namespace :api do
    namespace :v1 do
     resources :events, only: [:create]
    end
  end
  
end
