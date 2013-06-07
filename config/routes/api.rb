Brood::Application.routes.draw do
  #

  #about api
  match 'api/reg'  => 'api#reg'
  match 'api/online' => 'api#online'
  match 'api/sync' => 'api#sync'
  match 'api/offline' => 'api#offline'
  match 'api/roles' => 'api#roles'
  match 'api/readme' => 'api#readme'
 

end