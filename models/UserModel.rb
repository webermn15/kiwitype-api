class User < ActiveRecord::Base

	validates :username, :password_digest, :session_token, presence: true

	has_many :attempts
	has_many :excerpts, :through => :attempts
	has_secure_password

	before_validation :ensure_session_token

	def ensure_session_token
    self.session_token ||= generate_session_token
  end

	def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def lifetime_wpm
		that = self
    Attempt.select("wpm")
    	.where("user_id = ?", that.id)
	end

end