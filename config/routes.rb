Myrottenpotatoes::Application.routes.draw do
  resources :movies do
    resources :reviews
  end
  root :to => redirect('/movies')
  get  'auth/:provider/callback' => 'sessions#create'
  get '/sessions/logout' => 'sessions#destroy'
end
