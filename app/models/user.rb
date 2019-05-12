class User < ApplicationRecord
  before_save { email.downcase! }
  has_many :works,dependent: :destroy

  validates :name,  presence: true, length: { maximum:  50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  validates :affiliation,  presence: true, length: { maximum:  20 }

  #validates :basic_time,  presence: true

  #validates :specified_time,  presence: true 

end
