class Movie < ApplicationRecord
  validates :id, uniqueness: true
  validates :title, presence: true
end
