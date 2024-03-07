Rails.application.routes.draw do
  
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

    resources :posts,only: [:show, :edit, :index, :create, :new, :update, :destroy]
    resources :users, only: [:show, :edit, :index, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
