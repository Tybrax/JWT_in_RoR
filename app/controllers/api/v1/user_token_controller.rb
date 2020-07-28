module Api
    module V1
        class UserTokenController < Knock::AuthTokenController
            # ADD THIS LINE IN RAILS 6
            skip_before_action :verify_authenticity_token

            def entity_name
                'User'
            end
        end
    end
end
