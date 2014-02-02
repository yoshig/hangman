class WordToGuess

  attr_accessor :uncovered, :covered

  def initialize(word)
    @uncovered = word.split(//)
    @covered = @uncovered.map { |letter| "_" }
  end
end

class Hangman

  def initialize(guesser, creator)
    @total_guesses = 0

  end

  def choose_word
    
  end

  def game

  end
end

class HumanPlayer
end

class ComputerPlayer

  def initialize(iq = "dumb")
  end
end

