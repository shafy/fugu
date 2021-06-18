Rails.application.routes.draw do
  get ':username/:project_slug', to: 'projects#show', as: :project

  namespace :api do
    namespace :v1 do
     resources :events, only: [:create]
    end
  end
  
end
