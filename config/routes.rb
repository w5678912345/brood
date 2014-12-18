Brood::Application.routes.draw do
  
  resources :ip_ranges


  resources :account_statuses


  resources :support_roles


  resources :ip_filters

  resource :cpo , controller: "cpo" do 
    post :import, :on => :collection
  end

  resources :role_sessions
  resources :instance_maps do 
    get :level, :on => :collection
    put :reset_enter_count, :on => :collection
  end
  resources :links

  resources :history_role_sessions
  resources :account_tasks

  #
  devise_for :users,:path => '/'

  resources :todays, :only => [:index] do
    get :server_online,       :on => :collection
  end

  resources :accounts do 
    get   :merge,       :on => :collection
    post  :checked,     :on => :collection
    put   :do_checked,  :on => :collection
    get   :import,      :on => :collection
    post  :do_import,   :on => :collection
    get   :group_count, :on => :collection
    get   :setting,     :on => :collection
    post  :set,         :on => :collection

  end

  resources :expand_accounts do
    post :edit_enabled, :on => :collection
    put  :update_enabled, :on => :collection
    post :edit_in_cpo, :on => :collection
    put  :update_in_cpo, :on => :collection
  end

  #
  resources :data_nodes, :only => [:index] do 
    post :mark,         :on => :collection
    get  :chart,        :on => :collection
    get  :old_chart,    :on => :collection
  end

  #
  resources :roles do
    get		:home,  			:on => :collection
    get		:import, 			:on => :collection
    get 	:search,  		:on => :collection
    get 	:waiting,			:on => :collection
    get   :group_count, :on => :collection
    put   :task,        :on => :collection    
		get 	:notes,   		:on => :member
		get 	:payments, 		:on => :member
    put   :checked,     :on => :collection
    put   :do_checked,  :on => :collection
    #get   :computers,   :on => :member
  end

  resources :account_roles, :only => [:index] do 
    
  end

  resources :computers do 
    get   :group_count, :on=> :collection
    put   :update_accounts_count, :on => :collection
    get   :logs,      :on => :member
    get   :alogs,     :on => :member
    put   :enable,    :on => :member
    put   :checked,     :on => :collection
    put   :do_checked,  :on => :collection
    get   :discardforyears, :on=> :collection
    get   :run_anylize, :on=> :collection
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
  resources :notes , :only => [:index,:show] do
    get :analysis,   :on => :collection
    get :group_count, :on => :collection
    get :group_by_msg, :on => :collection
  end
  resources :sessions, :only => [:index,:show] do 
    get :computer,  :on => :collection
    get :account,   :on => :collection
    get :role,      :on => :collection
    get :analysis,  :on => :collection
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
  resources :phones do 
    put   :checked,     :on => :collection
    put   :do_checked,  :on => :collection
  end
  resources :phone_machines do
    member do
      get :can_unlock_accounts
    end
  end
  resources :orders,:only =>[:index] do
    put   :checked,     :on => :collection
    put   :do_checked,  :on => :collection
  end
  namespace :analysis do
    resource :oneday, :only =>[:show], controller: 'oneday'
    get "/oneday/roles/:mark" => "oneday#roles",:as => "roles_oneday"
    get "/oneday/notes" => "oneday#notes",:as => "notes_oneday"
    get "/oneday/effic" => "oneday#effic",:as => "effic_oneday"
    get "/oneday/trade" => "oneday#trade",:as => "trade_oneday"

    resource :multiday,:only => [:show], controller: 'multiday'
    resource :everyday,:only => [:show], controller: 'everyday'
    resource :session, :only => [:show], controller: 'session'
    resource :note,    :only => [:show], controller: 'note'

  end

  namespace :gold do 
    get '/' => 'home#show'
    resource :home, :only => [:show],controller: 'home'
    resource :trade, :only => [:show],controller: 'trade' do
      get :search
    end
    resource :excel, :only => [:show], controller: 'excel' do 

    end
  end
	

  
  #root :to => 'api/base#readme'
   match '/f9260735315e01448823722a3c054349' => 'api/base#readme'

  #   #about api
  # match 'api/reg'  => 'api#reg'
  # match 'api/online' => 'api#online'
  # match 'api/sync' => 'api#sync'
  # match 'api/offline' => 'api#offline'
  # match 'api/roles' => 'api#roles'
  # match 'api/readme' => 'api#readme'

  namespace :api  do
    match '/' => 'base#ping'
    match '/doc' => 'base#doc'
    match '/hi' => 'base#hi'
    match '/is_open' => 'base#is_open'
    match '/reg'  => 'computers#reg'
    match '/set'  => 'computers#set'
    match '/cinfo' => 'computers#cinfo'
    resources :computers,:only => [] do 
      get :start,     :on => :collection
      get :sync,      :on => :collection
      get :stop,      :on => :collection
      get :note,      :on => :collection
      get :set,       :on => :collection
    end
    resources :tasks ,:only =>[],:defaults => {:format => 'json'} do
      match :pull,    :on => :collection
      match :call,    :on => :member
    end
    resources :roles ,:only => [:show],:defaults => { :format => 'json' } do
			# match :online, :on => :collection
   #    match :close,   :on => :member
   #    match :on,      :on => :member
   #    match :off,     :on => :member
   #    match :sync,    :on => :member
			# match :note,		:on => :member
			
   #    match :lock,    :on => :member
   #    match :unlock,  :on => :member
   #    match :lose,    :on => :member
   #    match :bslock,  :on => :member
   #    match :bs_unlock,:on => :member
   #    match :disable,     :on => :member
   #    #
			# match :add,			:on => :collection
      match :start,   :on => :member
      match :sync,    :on => :member
      match :pay,     :on => :member
      match :stop,    :on => :member
    end

    #
    resources :accounts, :only => [:index,:show],:defaults => {:format => 'json'} do 
      match :auto,   :on => :collection
      match :start,  :on => :collection
      match :stop,   :on => :collection
      match :sync,   :on => :collection
      match :note,   :on => :collection
      match :look,   :on => :collection
 
      # match :get,    :on => :member
      # match :set,    :on => :member
      # match :put,    :on => :member
    end

    resources :account, :only => [:index,:show],controller: 'account',:defaults => {:format => 'json'} do 
      match :bind_phone, :on => :collection
      match :auto,   :on => :collection
      match :start,  :on => :collection
      match :stop,   :on => :collection
      match :sync,   :on => :collection
      match :note,   :on => :collection
      match :look,   :on => :collection
      match :reg,    :on => :collection
      #
      match :role_start, :on => :collection
      match :role_note,  :on => :collection
      match :role_pay,   :on => :collection
      match :role_stop,  :on => :collection
      match :sub_order,  :on => :collection
      match :unlock,     :on => :collection
      match :role_start_count, :on => :collection
      match :get_unlock, :on => :collection
      match :get_bslock, :on => :collection
      match :upate_attr, :on => :collection
      match :set_rms_file,      :on => :collection
      match :check_ip,          :on => :collection
    end
    resources :phone_machine do
      match :bind_phones, :on => :collection
      match :can_unlock_accounts, :on => :collection
      match :shutdown, :on => :collection
      match :online, :on => :collection
    end
    resources :phones,:only => [:show] do 
      match :get,  :on => :collection
      match :get_unlock, :on => :collection
      match :qq_register, :on => :collection
      match :disable, :on => :collection
      match :bind, :on => :collection
      match :set_can_bind, :on => :collection
      match :set_can_unlock, :on => :collection
      match :pull, :on => :collection
      match :pulls, :on => :collection
      match :sent, :on => :collection
    end


    resources :phone, controller: 'phone' do
      match :get,   :on => :collection
      match :set_enable, :on => :collection
      match :set_channel_enable, :on => :collection
      match :pull,  :on => :collection
      match :sent,  :on => :collection
    end
    
    resources :orders, :only => [:show] do
      match :sub,  :on => :collection
      match :get,  :on => :collection
      match :end,  :on => :collection
    end

    resources :maps, :only => [:show] do 
      get :valid,   :on => :collection
    end

    
    resources :account_task,controller: 'account_task' do
      match :end,     :on => :collection
    end

    resources :support_roles , :only => [:index] do
       
    end

  end

end
