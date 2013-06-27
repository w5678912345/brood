Brood::Application.routes.draw do
  #
  devise_for :users,:path => '/'
  #
  resources :roles do
    get		:home,  			:on => :collection
    get		:import, 			:on => :collection
    get 	:can,     		:on => :collection
    get 	:online,  		:on => :collection
    get 	:offline,  		:on => :collection
    get 	:closed,   		:on => :collection
    get 	:not_closed, 	:on => :collection
    get 	:search,  		:on => :collection
    get 	:auto_off,    :on => :collection
		get 	:waiting,			:on => :collection
		put		:reset_vip_power,			:on => :collection    
		get 	:notes,   		:on => :member
		get 	:payments, 		:on => :member
		put		:off,					:on => :member
		
  end

  resources :computers do 
    get 	:home,  		:on => :collection
		get 	:checked,		:on => :collection
		get 	:unchecked,	:on => :collection
		put		:check,			:on	=> :collection
    get 	:notes, 		:on => :member
    get 	:roles, 		:on => :member
  end
  resources :ips,:only => [:index,:destroy,:show] do 
    get :clear, 		:on => :collection
    put :reset, 		:on => :collection
    get :roles,			:on => :member
    get :notes,			:on => :member
  end
  resources :sheets ,:only =>[:index,:create,:destroy] do
    get :import, :on => :member
  end
  resources :notes do
    get :home, :on => :collection
    get :search, :on => :collection
    get :online, :on => :collection
    get :offline, :on => :collection
    get :sync,    :on => :collection
    get :close,   :on => :collection
    get :reg,     :on => :collection
  end
  #
  resources :settings, :only => [:index,:create,:edit,:update,:destroy]

  resources :versions, :only => [:index,:create,:destroy,:show,:new] do
    get :release, :on => :member
    get :s3,      :on => :collection
  end

	resources :payments , :only => [:index,:show] do
		get :home,		:on => :collection
		get :search,	:on => :collection
		get :roles,		:on => :collection		
	end

	resources :outputs, :only => [:index] do
		get :home,		:on => :collection
		get :search,	:on => :collection
		get :histroy,	:on => :collection
	end

	resources :users, :only => [:index,:new,:create,:show,:edit,:update,:destroy] do
				
	end
	

  
  root :to => 'api/base#readme'


  #   #about api
  # match 'api/reg'  => 'api#reg'
  # match 'api/online' => 'api#online'
  # match 'api/sync' => 'api#sync'
  # match 'api/offline' => 'api#offline'
  # match 'api/roles' => 'api#roles'
  # match 'api/readme' => 'api#readme'

  namespace :api  do
    match '/' => 'base#readme'
    match '/reg'  => 'computers#reg'
    resources :roles ,:only => [:show],:defaults => { :format => 'json' } do
			
      match :close,   :on => :member
      match :on,      :on => :member
      match :off,     :on => :member
      match :sync,    :on => :member
			match :note,		:on => :member
			match :pay,			:on => :member
      #
			match :add,			:on => :collection
      match :online, :on => :collection
    end
  end

end
