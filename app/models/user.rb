class User < ActiveRecord::Base

    USERNAME_REGEX = /[a-zA-Z0-9\-_]{0,20}/
    EMAIL_REGEX = /[a-zA-Z_0-9-.]+@getflywheel.com/i
    PASSWORD_REGEX = /.*(?=.{8,32})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^+=]).*/ 
	attr_accessor :remember_token, :activation_token
	
	#NOT FINAL IMPLEMENTATION
	before_save :downcase_email
	before_create :create_activation_digest

    validates :username, presence: true, uniqueness: { case_sensitive: false }#, 
    #	format: { with:  USERNAME_REGEX}
    validates :email, presence: true#, format: { with: EMAIL_REGEX }
    validates :password, presence: true#, format: { with: PASSWORD_REGEX}
    validates :salt, presence: true
	#encrypts the password
    def encrypt_password 
        if password.present?
            self.salt = BCrypt::Engine.generate_salt
            self.password = BCrypt::Engine.hash_secret(self.password, self.salt)
        end
    end
	#Cleas password after logout
    def clear_password
          self.password = nil
    end
	#Authenticates User
    def self.authenticate(username_or_email="", login_password="")
        if EMAIL_REGEX.match(username_or_email)
            user = User.find_by_email(username_or_email)
        else
            user = User.find_by_username(username_or_email)
        end
        if user && user.match_password(login_password)
            return user
        else
            return false
        end
    end
	#Matches the Password (returns if login_password matches database)
    def match_password(login_password="")
        self.password == BCrypt::Engine.hash_secret(login_password, salt)
    end
	#Generates a new, random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end
	#make sure the token is stored in the DB so that they can be authenticated
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end 
	#Compares digest to token
	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
			BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end
	#Returns true if token matches digest
	def authenticated?(remember_token)
		 BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end
	
	private
	def downcase_email
		self.email = email.downcase
	end
	
	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end
end
