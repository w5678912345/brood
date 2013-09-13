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
		get   :locked,      :on => :collection
    get   :unlocked,    :on => :collection
    get   :lost,        :on => :collection
    get   :unlost,      :on => :collection
    get 	:waiting,			:on => :collection
    get   :bslocked,    :on => :collection

		put		:reset_vip_power,			:on => :collection
		put 	:reopen_all,					:on => :collection
    put   :task,                :on => :collection    
		get 	:notes,   		:on => :member
		get 	:payments, 		:on => :member
		put		:off,					:on => :member
		put		:reopen,			:on => :member
		put   :unlock,      :on => :member
    put   :regain,       :on => :member
  end

  resources :computers do 
    get 	:home,  		:on => :collection
		get 	:checked,		:on => :collection
		get 	:unchecked,	:on => :collection
    get   :version,   :on => :collection
		put		:check,			:on	=> :collection
    get 	:notes, 		:on => :member
    get 	:roles, 		:on => :member
    get   :logs,      :on => :member
    get   :alogs,     :on => :member
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

  resources :servers ,:except => [:destroy] do 
    get :home,    :on => :collection
  end

  resources :tasks do
    get :list,    :on => :collection
    get :home,    :on => :collection
    get :pre,     :on => :member
    put :confirm, :on => :member
  end

  #resource :gold,controller: 'gold'

  resources :tests

  # get "analysis/by/:date" => "analysis#by"
  # get "analysis/roles/:mark" => "analysis#roles",:as => "roles_analysis"
  # get "analysis/notes/:mark" => "analysis#notes",:as => "notes_analysis"
  
  # resources :analysis,:only => [:index] do 
  #     get :home,  :on => :collection
  #     get :online,:on => :collection
  #     #get :roles, :on => :collection
  #     get :notes, :on => :collection
  #     get :test,  :on => :collection
       
  # end

  namespace :analysis do
    resource :oneday, :only =>[:show], controller: 'oneday'
    get "/oneday/roles/:mark" => "oneday#roles",:as => "roles_oneday"
    get "/oneday/notes" => "oneday#notes",:as => "notes_oneday"
    get "/oneday/effic" => "oneday#effic",:as => "effic_oneday"
    get "/oneday/trade" => "oneday#trade",:as => "trade_oneday"

    resource :multiday,:only => [:show], controller: 'multiday'

  end

  namespace :gold do 
    get '/' => 'home#show'
    resource :home, :only => [:show],controller: 'home'
    resource :trade, :only => [:show],controller: 'trade' do
      get :search
    end
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
    match '/set'  => 'computers#set'
    match '/cinfo' => 'computers#cinfo'
    match '/computers/abn' => 'computers#abn'
    resources :tasks ,:only =>[],:defaults => {:format => 'json'} do
      match :pull,    :on => :collection
      match :call,    :on => :member
    end
    resources :roles ,:only => [:show],:defaults => { :format => 'json' } do
			
      match :close,   :on => :member
      match :on,      :on => :member
      match :off,     :on => :member
      match :sync,    :on => :member
			match :note,		:on => :member
			match :pay,			:on => :member
      match :lock,    :on => :member
      match :unlock,  :on => :member
      match :lose,    :on => :member
      match :bslock,  :on => :member
      match :bs_unlock,:on => :member
      match :abn,     :on => :member
      #
			match :add,			:on => :collection
      match :online, :on => :collection
    end
  end

end
