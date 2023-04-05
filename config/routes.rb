Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "games#index"

  resources :games, except: [:edit, :update, :destroy] do
    get 'search', on: :collection, constraints: { format: 'js' }
    # GET /games/search, meant to only be used with AJAX
  end

  resources :genres, except: [:new, :edit, :create, :update, :destroy]
  resources :platforms, except: [:new, :edit, :create, :update, :destroy]
  resources :platform_families, except: [:new, :edit, :create, :update, :destroy]

  get 'import/igdb'
  get 'import/psn'

  namespace :api do
    namespace :v1 do
      get 'igdb/search'
      post 'igdb/import'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
