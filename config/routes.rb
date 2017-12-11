Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', confirmations: 'confirmations' },
    path: '', path_names: { sign_in: 'login', sign_out: 'logout', edit: 'settings'}

  root to: "home#index"

  get 'search', to: 'search#index'

  resources :profiles, only: [:show, :update, :edit], path: '/' do
    resources :albums do
      resources :photos do
        member do
          patch :set_avatar
          delete :remove_avatar
        end
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

    resources :conversations, only: [:index, :create, :show] do
      member do
        patch :read
      end
      resources :messages, only: [:create]
    end
  end

  resources :tags, only: [:show] do
    get 'fetch', on: :collection
  end

  get   ':likeable_type/:likeable_id/likes', to: 'likes#fetch',  constraints: LikeableTypeRouteConstraint.new, as: 'likes'
  patch ':likeable_type/:likeable_id/like',  to: 'likes#toggle', constraints: LikeableTypeRouteConstraint.new, as: 'like'

  mount ActionCable.server => '/cable'
end
