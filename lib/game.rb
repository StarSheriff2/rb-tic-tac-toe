class Game
  attr_accessor :game, :name, :players, :player_turn
  attr_reader :winner

  WINNING_COMBINATIONS = [[1, 2, 3], [7, 8, 9], [1, 4, 7], [3, 6, 9], [4, 5, 6], [2, 5, 8], [1, 5, 9], [3, 5, 7]].freeze

  def initialize
    @winner = nil
    @game = Array.new(10)
    @game[0] = 'empty'
    @players = []
    @player_turn = 0
  end

  def see_game
    @game
  end

  def turn(move, player)
    if move > 9 || move <= 0
      "error! Please select any number from 1 to 9\n"
    elsif !@game[move].nil?
      "error! That position is already taken\n"
    else
      @game[move] = player.symbol
      player.moves.push(move)
      win(player.moves, player.name)
      change_turn
      "\n#{player.name}, you selected position #{move}. Now your move is displayed on the board.\n"
    end
  end

  def change_turn
    self.player_turn = @player_turn.zero? ? 1 : 0
  end

  def print_winner
    @winner == 'draw' ? 'It\'s a draw!' : "Congrats, #{@winner}! You won this match!"
  end

  def win(moves, player)
    if moves.length > 2
      WINNING_COMBINATIONS.each { |combination| return @winner = player if (combination & moves) == combination }
    end
    @winner = 'draw' if @game.all?
  end
end
