Rails.application.routes.draw do
  root to: "campaigns#index"
  mount ActionCable.server => '/cable'
  devise_for :users
  post '/encounters/monsters/:monster_id', to: 'encounters#add_monster'
  get '/encounters/total_difficulty', to: 'encounters#total_difficulty'
  get '/encounters/monsters/new', to: 'encounters#new_monster'
  get '/encounters/npcs/new', to: 'encounters#new_monster'

  resources :players, :monsters, :spells, :characters, :campaigns, :books, :chapters, :search, :pages, :magic_items, :inkarnate, :set_characters, :npcs, :maps

  get '/rooms/:room/encounters/:id', to: 'encounters#show'
  put '/rooms/:room/encounters/:id', to: 'encounters#update'

  resources :rooms, param: :room


  resources :encounters do
    resources :encounter_monsters, :npcs
  end

  resources :campaigns do
    resources :books, :maps
  end

  resources :books do
    resources :chapters
  end

  resources :chapters do
    resources :pages
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
