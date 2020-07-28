class User < ApplicationRecord
    # need the bcrypt gem
    has_secure_password

    # for decrypting token and extract data from it in the client side
    def to_token_payload
        {
            id: id,
            email: email
        }
    end
end
