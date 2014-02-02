class OfficialWord

  attr_accessor :uncovered, :covered

  def initialize(word)
    @uncovered = word.split(//)
    @covered = @uncovered.map { |letter| "_" }
  end

  def good_guess?(guess_letter)
    letter_in_word = 0
    @uncovered.map!.with_index do |space, index|
      if space == guess_letter
        @covered[index] = guess_letter
        letter_in_word +=1
        "_"
      else
        space
      end
    end

    letter_in_word != 0 ? true : false
  end

  def found?
    @uncovered.all? { |x| x == "_" }
  end

  def current_state
    puts @covered.join(' ')
  end
end

class HangMan
  attr_accessor :total_guesses, :guesser, :creator

  def initialize(guesser, creator, total_guesses = 6)
    @total_guesses = total_guesses

    @guesser = guesser
    @creator = creator

    @hidden_word = "blank"
    @guessed_letters = []

    @dictionary = File.readlines('dictionary.txt')
    @dictionary.map! { |word| word.chomp }
  end

  def creator_creates
    word_entry = ""
    until @dictionary.include?(word_entry)
      word_entry = @creator.create_word
      unless @dictionary.include?(word_entry)
        puts "That's not a real word (according to our dictionary)." 
      end
    end

    @hidden_word = OfficialWord.new(word_entry)
  end

  def game
    creator_creates

    until @total_guesses == 0 || @hidden_word.found?

      puts "You have #{@total_guesses} guesses left"
      puts "Already guessed: #{@guessed_letters}"
      @hidden_word.current_state

      current_guess = ""
      until valid?(current_guess)
        current_guess = guesser.guess
        unless valid?(current_guess)
          puts "Guess is not valid"
        end
      end

      @guessed_letters << current_guess
      @total_guesses -= 1 unless @hidden_word.good_guess?(current_guess)

    end

    if @hidden_word.found?
      puts "YOU WIN"
      tell_word
    else
      puts "YOU LOSE"
      tell_word
    end
  end

  def tell_word
    puts "The word was #{@hidden_word}"
  end

  def valid?(letter)
    ("a".."z").include?(letter) && not_guessed?(letter)
  end

  def not_guessed?(letter)
    !@guessed_letters.include?(letter)
  end
end

class HumanPlayer
  def create_word
    puts "What word would you like the guesser to guess?"
    gets.chomp.downcase
  end

  def guess
    puts "Guess a letter"
    gets.chomp.downcase
  end
end

class ComputerPlayer
  def initialize(iq = "dumb")
    @iq = iq

    @dictionary = File.readlines('dictionary.txt')
    @dictionary.map! { |word| word.chomp }
  end

  def create_word
    x = @dictionary.sample
  end

  def guess
    if @iq == "dumb"
      ("a".."z").to_a.sample
    else
      #Put intelligent guesses here
    end
  end
end


comp = ComputerPlayer.new
me = HumanPlayer.new
new_game = HangMan.new(me, me)
new_game.game

word = OfficialWord.new("hat")
word.good_guess?("w")