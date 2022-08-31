class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}

    attr_reader :password

    before_validation :ensure_session_token

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def is_password?(password)
        pwo = BCrypt::Password.new(self.password_digest)
        pwo.is_password?(password)
    end

    def reset_session_token!
        self.session_token = generate_unique_token
        self.save
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_token
    end

    def generate_unique_token
        token = SecureRandom::urlsafe_base64

        while User.exists?(session_token: token)
            token = SecureRandom::urlsafe_base64
        end

        token
    end


    has_many :goals,
        foreign_key: :user_id,
        class_name: :Goal
end
