class User < ActiveRecord::Base
  belongs_to :dentist
  belongs_to :insurance
  has_many :comments
  validates_presence_of :name, message: "Must provide name."
  validates_presence_of :email, message: "Must provide email."
  validates_presence_of :insurance_id
  validates_presence_of :dentist_id
  validates :email, uniqueness: true
  validates_presence_of :password_digest, message: "Must provide password."
  has_secure_password


end
