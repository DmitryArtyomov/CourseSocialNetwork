Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' },
    path: '', path_names: { sign_in: 'login', sign_out: 'logout', edit: 'settings'}
  
  root to: "home#index"

  get 'edit', to: "profiles#edit", as: 'edit_profile'
  put 'edit', to: 'profiles#update', as: 'profile'
  get '/id:id', to: 'profiles#show', as: 'show_profile'

  resources :photos
end
