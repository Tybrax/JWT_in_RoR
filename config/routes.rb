Rails.application.routes.draw do

  #API
    namespace :api do
        namespace :v1 do
            post 'user_token' => 'user_token#create'
            resources :locations do
                resources :recordings
            end
        end
    end

    #BROWSER
    resources :locations
end
