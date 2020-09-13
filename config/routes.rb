Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    post 'signup', to: 'users#signup'
    post 'login', to: 'users#login'
    get 'auto_login', to: 'users#auto_login'
    get 'today', to: 'days#today'
    patch 'today', to: 'days#update_today'
    resources :days, only: [:index]
  end
end
