ActionController::Routing::Routes.draw do |map|
  map.resources :cuesheet
  map.resources :track
  map.resources :song

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
