Rails.application.routes.draw do
  post '/encounters/monsters/:monster_id', to: 'encounters#add_monster'
  get '/encounters/total_difficulty', to: 'encounters#total_difficulty'
  get '/encounters/monsters/new', to: 'encounters#new_monster'

  resources :players, :monsters, :spells, :characters, :campaigns, :books, :chapters, :search, :pages, :magic_items, :encounters

  resources :campaigns do
    resources :books
  end

  resources :books do
    resources :chapters
  end

  resources :chapters do
    resources :pages
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
