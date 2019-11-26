class Board < ApplicationRecord
  # validations
  validates_presence_of :rows, :dices
end
