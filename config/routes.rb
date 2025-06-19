Rails.application.routes.draw do
  root "pages#home"
  get "about", to: "pages#about"
  resources :articles, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
end
