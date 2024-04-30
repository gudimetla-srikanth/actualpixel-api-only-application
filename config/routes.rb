Rails.application.routes.draw do
  get '/nr',to:"application#index"
  post '/nr',to:"application#post_app"
end
