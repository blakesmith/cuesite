ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'cuesheets', :action => 'index'
  map.resources :cuesheets
  map.resources :track
  map.resources :song

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
