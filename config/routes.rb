Vote3::Application.routes.draw do
  resources :posts do
    resources :users
    member do
      post :vote_up
    end
  end

  post '/vote' => 'posts#vote'

  root :to => 'posts#new'

end
