Rails.application.routes.draw do

    #API
    namespace :api do
        namespace :v1 do
            resources :locations do
                resources :recordings
            end
        end
    end

    #BROWSER
    resources :locations
end
