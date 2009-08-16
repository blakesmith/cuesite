ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'cuesheets', :action => 'index'
  map.resources :cuesheets
  map.resources :tracks
  map.resources :songs

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
