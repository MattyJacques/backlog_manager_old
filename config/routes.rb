Rails.application.routes.draw do
  resources :games, except: [:new, :edit, :create, :update, :destroy]
  resources :genres, except: [:new, :edit, :create, :update, :destroy]
  resources :platforms, except: [:new, :edit, :create, :update, :destroy]
  resources :platform_families, except: [:new, :edit, :create, :update, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
