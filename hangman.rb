class OfficialWord

  attr_accessor :uncovered, :covered

  def initialize(word)
    @uncovered = word.split(//)
    @covered = @uncovered.map { |letter| "_" }
  end
end

class Hangman
  attr_accessor :total_guesses, :guesser, :creator

  def initialize(guesser, creator, total_guesses = 10)
    @total_guesses = total_guesses
    @guesser = guesser
    @creator = creator

    # I put the dictionary in the hangman class so that both the guesser
    # and creator have to go by the 'official' dicionary
    @dictionary = File.readlines('dictionary.txt')
    @dictionary.map! { |word| word.chomp }
  end

  def creator_creates
    word_entry = ""
    until dictionary.include?(word_entry)
      hidden_word = @creator.choose_word
      unless dictionary.include?(word_entry)
        puts "That's not a real word (according to our dictionary)." 
      end
    end

    hidden_word = OfficialWord.new(word_entry)
  end

  def game
    creator_creates

  end
end

class HumanPlayer

  def initialize
  end

  def choose_word
    puts "What word would you like the guesser to guess?"
    gets.chomp
  end
end

class ComputerPlayer

  def initialize(dictionary,iq = "dumb")
    @iq = iq
  end

  def choose_word
    @dictionary.sample
  end
end


comp = ComputerPlayer.new
me = HumanPlayer.new
new_game = HangMan.new