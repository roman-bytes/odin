require 'yaml'

class Hangman
  DICTIONARY_FILE = 'google-10000-english-no-swears.txt'
  MAX_GUESSES = 6

  attr_reader :secret_word, :current_word, :wrong_guesses, :remaining_guesses

  def initialize(load_game = nil)
    if load_game
      load_state(load_game)
    else
      @secret_word = select_random_word
      @current_word = Array.new(@secret_word.length, '_')
      @wrong_guesses = []
      @remaining_guesses = MAX_GUESSES
    end
  end

  def play
    puts 'Welcome to Hangman!'
    puts "Guess the word, one letter at a time. You have #{MAX_GUESSES} wrong guesses allowed."
    puts "Enter 'SAVE' at any time to save your game."

    until game_over?
      display_game_state
      take_turn
    end
    display_game_state
    announce_result
  end

  private

  def select_random_word
    dictionary = File.readlines(DICTIONARY_FILE, chomp: true)
    valid_words = dictionary.select { |word| word.length.between?(5, 12) }
    valid_words.sample
  end

  def display_game_state
    puts "\nWord: #{current_word.join(' ')}"
    puts "Wrong guesses: #{wrong_guesses.empty? ? 'None' : wrong_guesses.join(', ')}"
    puts "Guesses remaining: #{remaining_guesses}"
    puts "\n"
  end

  def take_turn
    guess = get_player_input
    return save_game if guess == 'SAVE'

    process_guess(guess)
  end

  def get_player_input
    loop do
      print "Enter a letter (or 'SAVE' to save game): "
      input = gets.chomp.upcase
      return input if input == 'SAVE'
      return input if valid_guess?(input)

      puts 'Invalid input! Use a single letter not yet guessed.'
    end
  end

  def valid_guess?(input)
    input.length == 1 && input.match?(/[A-Z]/) &&
      !(@current_word.include?(input) || @wrong_guesses.include?(input))
  end

  def process_guess(guess)
    if @secret_word.include?(guess)
      update_current_word(guess)
    else
      @wrong_guesses << guess
      @remaining_guesses -= 1
    end
  end

  def update_current_word(guess)
    @secret_word.chars.each_with_index do |char, i|
      @current_word[i] = guess if char == guess
    end
  end

  def game_over?
    won? || lost?
  end

  def won?
    @current_word.join == @secret_word
  end

  def lost?
    @remaining_guesses <= 0
  end

  def announce_result
    if won?
      puts "Congratulations! You guessed the word: #{@secret_word}"
    else
      puts "Game Over! The word was: #{@secret_word}"
    end
  end

  def save_game
    print 'Enter save file name: '
    filename = gets.chomp
    File.write(filename + '.yaml', YAML.dump(self))
    puts "Game saved as #{filename}.yaml"
  end

  def load_state(filename)
    saved_game = YAML.load_file(filename)
    @secret_word = saved_game.secret_word
    @current_word = saved_game.current_word
    @wrong_guesses = saved_game.wrong_guesses
    @remaining_guesses = saved_game.remaining_guesses
  end
end

def start_game
  puts 'Welcome to Hangman!'
  loop do
    print 'Would you like to (N)ew game or (L)oad saved game? [N/L]: '
    choice = gets.chomp.upcase
    case choice
    when 'N'
      return Hangman.new
    when 'L'
      print 'Enter save file name (without .yaml): '
      filename = gets.chomp + '.yaml'
      return Hangman.new(filename) if File.exist?(filename)

      puts 'File not found!'

    else
      puts 'Invalid choice! Enter N or L.'
    end
  end
end

if __FILE__ == $0
  # Ensure dictionary file exists
  unless File.exist?(DICTIONARY_FILE)
    puts "Dictionary file '#{DICTIONARY_FILE}' not found!"
    puts 'Please download it from: https://github.com/first20hours/google-10000-english'
    exit
  end

  game = start_game
  game.play
end
