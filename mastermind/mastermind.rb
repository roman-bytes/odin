class Mastermind
  COLORS = %w[R G B Y P O] # Red, Green, Blue, Yellow, Purple, Orange
  CODE_LENGTH = 4
  MAX_TURNS = 12

  class Board
    attr_reader :secret_code, :guesses, :feedback

    def initialize(secret_code = nil)
      @secret_code = secret_code || Array.new(CODE_LENGTH) { COLORS.sample }
      @guesses = []
      @feedback = []
    end

    def add_guess(guess)
      @guesses << guess
      @feedback << evaluate_guess(guess)
    end

    def evaluate_guess(guess)
      exact = exact_matches(guess)
      color = color_matches(guess) - exact
      { exact: exact, color: color }
    end

    def display
      puts "\nColors: #{COLORS.join(', ')}"
      puts "Turns left: #{MAX_TURNS - guesses.length}"
      puts 'Guesses:'
      guesses.each_with_index do |guess, i|
        puts "#{guess.join(' ')} | Exact: #{feedback[i][:exact]}, Color: #{feedback[i][:color]}"
      end
      puts "\n"
    end

    def won?
      guesses.last == secret_code
    end

    private

    def exact_matches(guess)
      guess.zip(secret_code).count { |g, s| g == s }
    end

    def color_matches(guess)
      secret = secret_code.dup
      guess.count { |color| secret.delete_at(secret.index(color)) if secret.include?(color) }
    end
  end

  class ComputerPlayer
    def initialize
      @possible_codes = COLORS.repeated_permutation(CODE_LENGTH).to_a
      @last_guess = nil
      @last_feedback = nil
    end

    def make_guess
      if @last_guess.nil?
        # First guess: random
        @last_guess = Array.new(CODE_LENGTH) { COLORS.sample }
      else
        # Filter possible codes based on last feedback
        @possible_codes.select! do |code|
          feedback = evaluate_guess_against(code, @last_guess)
          feedback == @last_feedback
        end
        @last_guess = @possible_codes.sample || COLORS.repeated_permutation(CODE_LENGTH).to_a.sample
      end
    end

    def update_feedback(feedback)
      @last_feedback = feedback
    end

    private

    def evaluate_guess_against(code, guess)
      exact = guess.zip(code).count { |g, s| g == s }
      color = guess.count { |c| code.include?(c) } - exact
      { exact: exact, color: color }
    end
  end

  def initialize
    @mode = choose_mode
    setup_game
  end

  def play
    puts 'Welcome to Mastermind!'
    puts "Use first letters of colors: #{COLORS.join(', ')}"

    MAX_TURNS.times do
      @board.display
      break if take_turn
      return puts "Game over! Secret code was: #{@board.secret_code.join(' ')}" if @board.guesses.length == MAX_TURNS
    end
  end

  private

  def choose_mode
    loop do
      print 'Do you want to be the code maker (M) or guesser (G)? [M/G]: '
      choice = gets.chomp.upcase
      return choice if %w[M G].include?(choice)

      puts 'Invalid choice. Please enter M or G.'
    end
  end

  def setup_game
    if @mode == 'G'
      @board = Board.new
    else
      @board = Board.new(get_human_code)
      @computer = ComputerPlayer.new
    end
  end

  def get_human_code
    loop do
      print "Enter your secret code (#{CODE_LENGTH} colors, e.g., R G B Y): "
      code = gets.chomp.upcase.split
      return code if valid_code?(code)

      puts "Invalid code! Use #{CODE_LENGTH} colors from: #{COLORS.join(', ')}"
    end
  end

  def valid_code?(code)
    code.length == CODE_LENGTH && code.all? { |c| COLORS.include?(c) }
  end

  def take_turn
    if @mode == 'G'
      guess = get_human_guess
      @board.add_guess(guess)
      if @board.won?
        @board.display
        puts 'Congratulations! You cracked the code!'
        true
      else
        false
      end
    else
      guess = @computer.make_guess
      puts "Computer's guess: #{guess.join(' ')}"
      @board.add_guess(guess)
      feedback = @board.feedback.last
      @computer.update_feedback(feedback)
      if @board.won?
        @board.display
        puts 'Computer cracked your code!'
        true
      else
        get_human_feedback
        false
      end
    end
  end

  def get_human_guess
    loop do
      print "Enter your guess (#{CODE_LENGTH} colors, e.g., R G B Y): "
      guess = gets.chomp.upcase.split
      return guess if valid_code?(guess)

      puts "Invalid guess! Use #{CODE_LENGTH} colors from: #{COLORS.join(', ')}"
    end
  end

  def get_human_feedback
    @board.display
    puts "Code maker, provide feedback for computer's guess:"
    exact = get_number('Exact matches (same color, same position): ', 0..CODE_LENGTH)
    color = get_number('Color matches (right color, wrong position): ', 0..(CODE_LENGTH - exact))
    @computer.update_feedback({ exact: exact, color: color })
  end

  def get_number(prompt, range)
    loop do
      print prompt
      num = gets.chomp.to_i
      return num if range.include?(num)

      puts "Please enter a number between #{range.min} and #{range.max}"
    end
  end
end

# Start the game
Mastermind.new.play if __FILE__ == $0
