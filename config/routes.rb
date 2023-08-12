Rails.application.routes.draw do
  resources :articles do
    member do
      post 'comment'
      post 'reaction'
      patch 'reaction', to: 'articles#update_reaction'
      delete 'reaction', to: 'articles#remove_reaction'
    end
  end

    devise_for :users

    root "articles#index"
end
