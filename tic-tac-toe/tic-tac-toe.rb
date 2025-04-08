class Board
  def initialize
    # Initialize 3x3 grid with numbers 1-9 as position markers
    @grid = (1..9).to_a
  end

  def display
    # Display the board in a 3x3 grid format
    puts "\n"
    0.upto(2) do |row|
      puts " #{@grid[row * 3]} | #{@grid[row * 3 + 1]} | #{@grid[row * 3 + 2]} "
      puts '---+---+---' unless row == 2
    end
    puts "\n"
  end

  def update(position, marker)
    # Update the board if position is valid and available
    pos = position - 1
    return false unless valid_move?(pos)

    @grid[pos] = marker
    true
  end

  def valid_move?(pos)
    # Check if position is within bounds and still a number (not taken)
    pos.between?(0, 8) && @grid[pos].is_a?(Integer)
  end

  def win?(marker)
    # Check all winning combinations
    winning_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
      [0, 4, 8], [2, 4, 6] # Diagonals
    ]

    winning_combinations.any? do |combo|
      combo.all? { |pos| @grid[pos] == marker }
    end
  end

  def full?
    # Check if board is full (no numbers left)
    @grid.all? { |cell| cell.is_a?(String) }
  end
end

class Game
  def initialize
    @board = Board.new
    @players = %w[X O]
    @current_player = 0
  end

  def play
    puts 'Welcome to Tic-Tac-Toe!'
    puts 'Enter numbers 1-9 to make your move'

    loop do
      @board.display
      take_turn
      if game_over?
        @board.display
        announce_result
        break
      end
      switch_players
    end
  end

  private

  def take_turn
    loop do
      print "Player #{@players[@current_player]}, enter your move (1-9): "
      move = gets.chomp.to_i
      break if @board.update(move, @players[@current_player])

      puts 'Invalid move! Try again.'
    end
  end

  def switch_players
    @current_player = (@current_player + 1) % 2
  end

  def game_over?
    @board.win?(@players[@current_player]) || @board.full?
  end

  def announce_result
    if @board.win?(@players[@current_player])
      puts "Player #{@players[@current_player]} wins!"
    else
      puts "It's a tie!"
    end
  end
end

# Start the game
Game.new.play if __FILE__ == $0
