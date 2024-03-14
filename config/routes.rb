Rails.application.routes.draw do
  
  namespace :user do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  devise_for :users,skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}

  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "user/sessions#guest_sign_in"
  end

  namespace :user, path: '' do
    root to: 'homes#top'

    resources :posts,only: [:show, :edit, :index, :create, :new, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
    end
    
    resources :users, only: [:show, :edit, :index, :update] do
      member do
        get :favorites 
      end
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    
    get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'

    get "search" => "searches#search"
    
    resources :messages, only: [:create]
    resources :rooms, only: [:create,:show]
  end

  namespace :admin do
    root to: 'user_managements#index'
    resources :user_managements, only: [:index, :show, :edit, :update, :destroy]
  end
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end