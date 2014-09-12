require 'bcrypt'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  # this will store both th password and the salt
  # It's Text and not String because String holds
  # 50 characters by default
  # and it's not enough for the hash and salt
  property :password_digest, Text

  attr_reader :password
  attr_writer :password_confirmation


  validates_confirmation_of :password, :message => "Sorry, your passwords don't match"
  #validates_uniqueness_of :email  #This line is not necessary because we have
  #called for uniqueness on the email porperty. However, some ORM's require
  #this line, so check.

  # when the password is assigned it will not be stored directly
  # instead a password digest is created, i.e.
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and will be saved to the database. BCrypt provides this and it contains
  # both the hash and the salt. This will then be saved to the database for
  # securtiy reasons.

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user =  first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end
end
