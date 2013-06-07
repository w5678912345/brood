Brood::Application.routes.draw do
  #
  devise_for :users,:path => '/'
  #
  resources :roles do
    get :import, :on => :collection
  end

  resources :computers
  resources :ips,:only => [:index,:destroy] do 
    get :clear, :on => :collection
  end
  resources :sheets ,:only =>[:index,:create,:destroy] do
    get :import, :on => :member
  end
  
 # root :to => 'api#readme'

end
