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
    get :detail,:on => :member
  end
  resources :sheets ,:only =>[:index,:create,:destroy] do
    get :import, :on => :member
  end
  resources :notes do
    get :home, :on => :collection
  end
  
  root :to => 'api#readme'

end
