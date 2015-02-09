class User < ActiveRecord::Base
  include BCrypt

  has_many :portfolios
  validates :email, presence: true, email: true
  validates :username, presence: true

  def password
    @password ||= Password.new(self.password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end
