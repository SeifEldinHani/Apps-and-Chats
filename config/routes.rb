Rails.application.routes.draw do
  namespace :api, defaults: {format: :json}  do
      namespace :v1 do
        resources :apps 
        resources :chats
        resources :messages
    end
  end
end