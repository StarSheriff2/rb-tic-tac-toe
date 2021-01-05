require_relative '../lib/game'
require_relative '../lib/instructions'
require_relative '../lib/player'

describe Game do
  describe '#win' do
    context 'when player has one straight line on the board' do
      subject(:game_win) { described_class.new }
      let(:player) { instance_double(Player, name: 'Charles', moves: [1, 2, 3]) }

      it "changes @winner to player's name" do
        winner_name = player.name
        moves = player.moves
        game_win.win(moves, winner_name)
        winner = game_win.winner
        expect(winner).to eq('Charles')
      end

      it "changes @winner to player's name if line is in reverse order" do
        winner_name = player.name
        moves = player.moves
        game_win.win(moves, winner_name)
        winner = game_win.winner
        expect(winner).to eq('Charles')
      end
    end

    context 'when player has no straight line on the board' do
      subject(:game) { described_class.new }
      let(:player_x) { instance_double(Player, name: 'Tony', moves: [1, 2, 4, 5]) }

      it "it doesn\'t change @winner variable" do
        current_player = player_x.name
        moves = player_x.moves
        game.win(moves, current_player)
        winner = game.winner
        expect(winner).to_not eq('Tony')
      end
    end

    context 'when there are no moves left and no straight line on the board' do
      subject(:game_draw) { described_class.new }
      let(:player_x) { instance_double(Player, moves: [1, 3, 6, 7, 8]) }

      it "changes @winner to \'draw\'" do
        moves = player_x.moves
        game_draw.game = %w[X O X O O X X X O]
        game_draw.win(moves, player_x)
        winner = game_draw.winner
        expect(winner).to eq('draw')
      end
    end

    context 'when a player has made less than 3 moves' do
      subject(:game_less_moves) { described_class.new }
      let(:player) { instance_double(Player, moves: [1, 2]) }
      let(:winning_combinations) { object_double('Game::WINNING_COMBINATIONS').as_stubbed_const }

      it 'does not send each' do
        moves = player.moves
        expect(winning_combinations).to_not receive(:each)
        game_less_moves.win(moves, player)
      end

      it 'does not change state of winner' do
        moves = player.moves
        game_less_moves.win(moves, player)
        winner = game_less_moves.winner
        expect(winner).not_to be_truthy
      end
    end
  end

  describe '#turn' do
    subject(:game_turn) { described_class.new }
    let(:player) { instance_double(Player) }

    context 'when user\'s position input is invalid' do
      it 'returns error message if move is not > 0 or < 10' do
        error_message = "error! Please select any number from 1 to 9\n"
        input = 10
        result = game_turn.turn(input, player)
        expect(result).to eq(error_message)
      end

      it 'returns error message if input is not a number' do
        error_message = "error! Please select any number from 1 to 9\n"
        input = 'a'.to_i
        result = game_turn.turn(input, player)
        expect(result).to eq(error_message)
      end

      it 'returns error message if input is a symbol' do
        error_message = "error! Please select any number from 1 to 9\n"
        input = '$'.to_i
        result = game_turn.turn(input, player)
        expect(result).to eq(error_message)
      end

      it 'returns error message if position is marked already on the board' do
        error_message = "error! That position is already taken\n"
        input = 2
        game_turn.game = %w[X O X]
        player = instance_double(Player)
        result = game_turn.turn(input, player)
        expect(result).to eq(error_message)
      end
    end

    context 'when user\'s position input is valid' do
      let(:player) { instance_double(Player, name: 'Johnny', moves: [1, 4]) }

      before do
        allow(game_turn).to receive(:win)
        allow(player).to receive(:symbol)
      end

      it 'returns a string with feedback about the selected position on the board' do
        text = "\nJohnny, you selected position 3. Now your move is displayed on the board.\n"
        input = 3
        result = game_turn.turn(input, player)
        expect(result).to eq(text)
      end

      it 'doesn\'t return error message related to invalid number, symbol or character' do
        error_message = "error! Please select any number from 1 to 9\n"
        input = 3
        result = game_turn.turn(input, player)
        expect(result).to_not eq(error_message)
      end

      it 'doesn\'t return error message about position already been taken' do
        error_message = "error! That position is already taken\n"
        input = 3
        result = game_turn.turn(input, player)
        expect(result).to_not eq(error_message)
      end
    end
  end

  describe '#change_turn' do
    subject(:game_change_turn) { described_class.new }

    it 'changes player_turn to 1 if @player_turn has a value of 0' do
      game_change_turn.player_turn = 0
      game_change_turn.change_turn
      player_turn = game_change_turn.player_turn
      expect(player_turn).to eq(1)
    end

    it 'doesn\'t return the current value in @player_turn again' do
      game_change_turn.player_turn = 1
      game_change_turn.change_turn
      player_turn = game_change_turn.player_turn
      expect(player_turn).to_not eq(1)
    end
  end
end
