class HangMan
  attr_accessor :total_guesses, :guesser, :creator

  def initialize(guesser, creator, total_guesses = 6)
    @total_guesses = total_guesses

    @guesser = guesser
    @creator = creator

    @guessed_letters = []

    @dictionary = File.readlines('dictionary.txt')
    @dictionary.map! { |word| word.chomp }
  end

  def creator_creates_word
    word_entry = ""
    until @dictionary.include?(word_entry)
      word_entry = @creator.create_word
      unless @dictionary.include?(word_entry)
        puts "That's not a real word (according to our dictionary)." 
      end
    end
  end

  def game
    creator_creates_word

    until @total_guesses == 0

      puts "You have #{@total_guesses} guesses left"
      puts "Already guessed: #{@guessed_letters}"
      show_board

      current_guess = get_valid_letter
      @guessed_letters << current_guess
      @total_guesses -= 1 unless @creator.say_good_guess?(current_guess)

      if @creator.lost?
        puts "#{guesser.name} wins"
        return tell_word
      end
    end

    puts "#{creator.name} wins"
    tell_word
  end

  def get_valid_letter
    current_guess = ""
    until valid?(current_guess)
      current_guess = guesser.guess(@creator.blanks)
      unless valid?(current_guess)
        puts "Guess is not valid"
      end
    end
    current_guess
  end

  def tell_word
    puts "The word was #{@creator.final.join}"
  end

  def valid?(letter)
    (("a".."z").include?(letter) || letter == "-") && not_guessed?(letter)
  end

  def not_guessed?(letter)
    !@guessed_letters.include?(letter)
  end

  def show_board
   p @creator.blanks
  end
end

class HumanPlayer
  attr_accessor :name, :blanks
  attr_reader :final

  def initialize(name)
    @name = name
  end

  def create_word
    puts "What word would you like the guesser to guess?"
    @final = gets.chomp.downcase
    @blanks = @final.split(//).map { |space| "_" }
    @secret_word = @final.dup
  end

  def guess(_)
    puts "Guess a letter"
    gets.chomp.downcase
  end

  def say_good_guess?(guess_letter)
    puts "Does your word (#{@secret_word}) contain #{guess_letter}? (y/n)"
    ans = gets.chomp.downcase
    if ans == "y"
      until ans == "n"
        puts "What index does it appear?"
        @blanks[gets.chomp.to_i] = guess_letter
        puts "Anywhere else?"
        ans = gets.chomp
      end
    else
      return false
    end
    true
  end

  def lost?
    p @blanks
    puts "Did they guess all the letters? (y/n)"
    ans = gets.chomp.downcase
    ans == "y" ? true : false
  end
end

class ComputerPlayer
  attr_accessor :name, :blanks
  attr_reader :final

  def initialize(name, iq = "dumb")
    @name = name
    @iq = iq

    @dictionary = File.readlines('dictionary.txt')
    @dictionary.map! { |word| word.chomp }

    @guessed_letters = []
    @final = ""
  end

  def create_word
    @final = @dictionary.sample.split(//)
    @blanks = @final.map { "_" }
    @secret_word = @final.dup
    @final.join
  end

  def say_good_guess?(guess_letter)
    letter_in_word = 0
    @secret_word.map!.with_index do |space, index|
      if space == guess_letter
        @blanks[index] = guess_letter
        letter_in_word +=1
        "_"
      else
        space
      end
    end

    letter_in_word != 0 ? true : false
  end

  def lost?
    @blanks.all? { |x| x != "_" }
  end

  def guess(hidden_word)
    if @iq == "dumb"
      ("a".."z").to_a.sample
    else
      find_right_length(hidden_word)
      narrow_by_guessed_letters
      narrow_by_right_letter_right_spot(hidden_word)
      choose_best_letter
    end
  end

  def find_right_length(hidden_word)
    @dictionary.keep_if do |word|
      word.length == hidden_word.length
    end
  end

  def narrow_by_guessed_letters
    @dictionary.delete_if do |word|
      word.split(//).each do |letter|
        return true if @guessed_letters.include?(letter) &&
          !@final.include?(letter)
      end
      false
    end
  end

  def narrow_by_right_letter_right_spot(hidden_word)
    @dictionary.keep_if do |word|
      keep = true
      hidden_word.each_with_index do |letter, index|
        next if letter == "_"
        keep = false if letter != word[index] ||
          word.count(letter) != hidden_word.count(letter)
      end
      keep
    end
  end

  def choose_best_letter
    best_letters = Hash.new(0)

    @dictionary.each do |word|
      word.split(//).each do |letter|
        best_letters[letter] += 1
      end
    end

    best_guess_total = 0
    best_guess = ""

    best_letters.each do |letter, total|
      if total > best_guess_total && !@guessed_letters.include?(letter)
        best_guess = letter
        best_guess_total = total
      end
    end

    @guessed_letters << best_guess
    best_guess
  end
end


cp1 = ComputerPlayer.new("guesser", "smart")
cp2 = ComputerPlayer.new("creator", "smart")
me = HumanPlayer.new("Yoshi")
new_game = HangMan.new(cp1, cp2)
new_game.game