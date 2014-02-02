class WordToGuess

  attr_accessor :uncovered, :covered

  def initialize(word)
    @uncovered = word.split(//)
    @covered = @uncovered.map { |letter| "_" }
  end
end

class Hangman
  attr_accessor :total_guesses, :guesser, :creator

  def initialize(guesser, creator)
    @total_guesses = 0
    @guesser = guesser
    @creator = creator
  end

  def choose_word
    @creator.choose_word
  end

  def game

  end
end

class HumanPlayer
end

class ComputerPlayer

  def initialize(iq = "dumb")
    @iq = iq
    @dictionary = File.read('dictionary.txt')
  end
end

