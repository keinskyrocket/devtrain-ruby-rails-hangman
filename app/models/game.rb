class Game < ApplicationRecord
  MAX_LIVES = 9

  has_many :guesses, dependent: :delete_all
  validates_associated :guesses

  def self.load_secret_words
    File.open('db/words.txt').map { |word| word.strip }
  end

  # def load_secret_words
  #   File.open('db/words.txt').map { |word| word.strip }
  # end

  def remaining_lives
    MAX_LIVES - guesses.where.not(value: secret_word.chars).count
  end

  def letters_guessed
    guesses.pluck(:value)
  end

  def correct_guess
    guesses.where(value: secret_word.chars).pluck(:value).uniq.count
  end

  def formatted_updated_at
    updated_at.strftime("%Y/%m/%d - %H:%M")
  end

  def check_dupe?(letter)
    letters_guessed.include?(letter)
  end
end
