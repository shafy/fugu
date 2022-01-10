# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "projects#index"

  resources :projects, only: %i[index new create destroy], param: :slug do
    resources :events, only: %i[index show], param: :slug
    resources :funnels, param: :slug
    get "settings", to: "projects#settings"
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

  devise_for \
    :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords"
    }

  namespace :api do
    namespace :v1 do
      resources :events, only: %i[create]
    end
  end
end
