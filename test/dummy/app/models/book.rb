class Book < ApplicationRecord
  validates :title, :author, presence: true
end
