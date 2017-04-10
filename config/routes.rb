Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' },
    path: '', path_names: { sign_in: 'login', sign_out: 'logout', edit: 'settings'}
  
  root to: "home#index"

  get 'edit', to: "profile#edit", as: 'edit_profile'
  put 'edit', to: "profile#update", as: 'profile'
  get '/id:id', to: 'profile#show', as: 'show_profile'
end
