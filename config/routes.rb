Vote3::Application.routes.draw do
  resources :posts do
    resources :users
    member do
      post :vote_up
    end
  end

  root :to => 'posts#new'

end
