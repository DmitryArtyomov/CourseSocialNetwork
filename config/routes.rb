Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' },
    path: '', path_names: { sign_in: 'login', sign_out: 'logout', edit: 'settings'}

  root to: "home#index"

  resource :search, only: [:index]
  get 'search', to: 'search#index'

  resources :profiles, only: [:show, :update, :edit], path: '/' do
    resources :photos, except: [:update] do
      member do
        patch :set_avatar
        delete :remove_avatar
      end
    end

    resources :friend_requests, only: [:create, :destroy, :index], path: 'friend_requests' do
      member do
        patch :accept
        patch :decline
        delete :cancel
      end
    end

    resources :friends, only: [:index]
  end
end
