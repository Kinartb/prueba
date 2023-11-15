Myrottenpotatoes::Application.routes.draw do
  resources :movies
  root :to => redirect('/movies')
  get  'auth/:provider/callback' => 'sessions#create'
  get '/sessions/logout' => 'sessions#destroy'
end
