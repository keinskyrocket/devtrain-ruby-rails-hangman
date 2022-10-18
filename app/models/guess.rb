class Guess < ApplicationRecord
  belongs_to :game

  validates :value, format: { with: /\A[A-Z]{1}+\Z/, message: 'Only allows single letters between A and Z' }
end
