# Implement JSON Web Token into a RoR API

Build a weather app that returns weather recording for specific locations.

### Gems (bcrypt & knock)
- **gem 'bcrypt', '~> 3.1.7'**
- **gem 'knock', github: 'nsarno/knock', branch: 'master',ref: '9214cd027422df8dc31eb67c60032fbbf8fc100b'**

### Models
We want **data association** between locations and recordings
- *app/models/location.rb* :

``` Ruby
class Location < ApplicationRecord
    has_many :recordings
end
```

- *app/models/recording.rb*
``` Ruby
class Recording < ApplicationRecord
  belongs_to :location
end
```

- *app/models/user.rb*

``` Ruby
class User < ApplicationRecord
    # from bcrypt
    has_secure_password

    # for decrypting token and extract data from it in the client side
    def to_token_payload
        {
            id: id,
            email: email
        }
    end
end
```

### Controllers

Make sure to place the controllers within app/controllers/api/v1 folder. 
Wrap the controller class within module Api and module V1.

- *app/controllers/api/v1/locations_controller.rb*

``` Ruby
module Api
    module V1
        class LocationsController < ApiController
            before_action :set_location

            # GET /api/v1/locations/1
            def show
            end

            private

            def set_location
                @location = Location.find(params[:id])
            end
        end
    end
end
```

- *app/controllers/api/v1/user_token_controller.rb*

In Rails 6, make sure to add skip_before_action :verify_authenticity_token to the UserTokenController class

``` Ruby
module Api
    module V1
        class UserTokenController < Knock::AuthTokenController

            skip_before_action :verify_authenticity_token

            def entity_name
                'User'
            end
        end
    end
end
```

### Routes
- *config/routes.rb*

``` Ruby
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
```

### Seed database
- *db/seeds.rb*

``` Ruby
l = Location.create(name: "New York City")
l.recordings.create(temp: 32, status: "cloudy")
l.recordings.create(temp: 35, status: "rainy")
l.recordings.create(temp: 26, status: "cloudy")
l.recordings.create(temp: 16, status: "sunny")
```

### Views
- *app/views/api/v1/locations/show.json.jbuilder*

``` Ruby
json.id @location.id
json.name @location.name

json.current do
    json.temp @location.recordings.last.temp
    json.status @location.recordings.last.status
end
```

### Commands
- **bundle install** to install gems from the Gemfile
- **rails db:seed** to seed database using code from db/seeds.rb
- **rails db:migrate** to migrate data
- **rails routes** to display available routes
- **rails s -p 3001** to run a server on port 3001
- **rails c** to open the Ruby console within the Ruby interpreter

### Create a user using rails console
- Open the Ruby interpreter
- Navigate to the application folder
- Run the Ruby console
- Run the following code

``` Shell
User.create(email: "email@gmail.com", password: "123456", password_confirmation: "123456")
```

### API calls
- Create a user :

``` Shell
curl --data "auth[email]=email@gmail.com&auth[password]=12345678" http://localhost:3001/api/v1/user_token
```

- It returns a token :

``` JavaScript
{"jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTYwMDkxMDIsInN1YiI6MX0.tfnpNhYPLXktO3gDfnLV0hnVznJVuwOU6uhT8PZnPXY"}
```

- GET request to view data from the first location :

``` Shell
curl -v -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTYwMDkxMDIsInN1YiI6MX0.tfnpNhYPLXktO3gDfnLV0hnVznJVuwOU6uhT8PZnPXY" http://localhost:3001/api/v1/locations/1
```

- Check the payload :

``` JavaScript
const payload = window.atob(eyJleHAiOjE1OTYwMDkxMDIsInN1YiI6MX0);
```

payload.id to retrieve user ID
payload.email to retrieve user email address

More questions at bastien.ratat@gmail.com
