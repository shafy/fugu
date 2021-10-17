# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "projects#index"

  resources :projects, only: [:index, :new, :create]

  scope "projects/" do
    get "/:slug", to: "projects#show", as: :project
    get "/:slug/settings", to: "projects#settings", as: :project_settings
    delete "/:slug", to: "projects#destroy", as: :destroy_project
  end

  scope module: "users" do
    get "settings/", to: "settings#show", as: :users_settings
  end

  scope "stripe/" do
    get "/checkout_session/", to: "stripe#checkout_session", as: "stripe_checkout_session"
    get "/success_callback/", to: "stripe#success_callback", as: "stripe_success_callback"
    get "/customer_portal/", to: "stripe#customer_portal", as: "stripe_customer_portal"
    post "/webhooks/", to: "stripe#webhooks", as: "stripe_webhooks"
  end

  namespace :api do
    namespace :v1 do
      resources :events, only: [:create]
    end
  end
end
