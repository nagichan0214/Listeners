Rails.application.routes.draw do
  
  
  namespace :user do
    root to: 'homes#top'
    
    resources :posts,only: [:show, :edit, :index, :create, :new, :update, :destroy]
    resources :users, only: [:show, :edit, :index, :update]
  end
  
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  devise_for :users,skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
