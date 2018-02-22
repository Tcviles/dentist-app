class User < ActiveRecord::Base
  belongs_to :dentist
  belongs_to :insurance

  has_secure_password
end
