class Book < ApplicationRecord
  has_many :rentals
  has_many :users, through: :rentals
end
