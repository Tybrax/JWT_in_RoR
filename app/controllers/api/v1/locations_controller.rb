module Api
    module V1
        class LocationsController < ApiController
            before_action :set_location

            #http://localhost:3001/api/v1/locations/1.json to check the first record
            def show
            end

            private

            def set_location
                @location = Location.find(params[:id])
            end
        end
    end
end
