Rails.application.routes.draw do
  namespace :api do 
    namespace :v1 do 
      post "/signin", to: "sessions#signin"
      post "/signup", to: "sessions#signup"

      resources :writers 
      resources :books
    end
  end
end
