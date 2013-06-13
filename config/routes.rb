Brood::Application.routes.draw do
  #
  devise_for :users,:path => '/'
  #
  resources :roles do
    get :home,  :on => :collection
    get :import, :on => :collection
    get :can,     :on => :collection
    get :online,  :on => :collection
  end

  resources :computers
  resources :ips,:only => [:index,:destroy,:show] do 
    get :clear, :on => :collection
    get :reset, :on => :collection
    get :detail,:on => :member
  end
  resources :sheets ,:only =>[:index,:create,:destroy] do
    get :import, :on => :member
  end
  resources :notes do
    get :home, :on => :collection
  end
  #
  resources :settings, :only => [:index,:create,:edit,:update,:destroy]
  
  root :to => 'api#readme'


    #about api
  match 'api/reg'  => 'api#reg'
  match 'api/online' => 'api#online'
  match 'api/sync' => 'api#sync'
  match 'api/offline' => 'api#offline'
  match 'api/roles' => 'api#roles'
  match 'api/readme' => 'api#readme'

  namespace :api  do
    resources :roles ,:only => [:show] do
      match :close, :on => :member
    end
  end

end
