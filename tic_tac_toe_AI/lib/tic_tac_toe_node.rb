require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator) #evaluator is a mark
    if @board.over? #base case
      return nil if !@board.winner
      return @board.winner != evaluator
    end
    #recursive step
    if @next_mover_mark == evaluator #it is player's turn
      return true if self.children.all?{|node| node.losing_node?(evaluator)}
    else #it is opponent's turn
      return true if self.children.any?{|node| node.losing_node?(evaluator)}
    end

    false
  end

  def winning_node?(evaluator)
    if @board.over? #base case
      return nil if !@board.winner
      return @board.winner == evaluator
    end
    #inductive step
    if @next_mover_mark == evaluator #it is player's turn
      return true if self.children.any?{|node| node.winning_node?(evaluator)}
    else #it is opponent's turn
      return true if self.children.all?{|node| node.winning_node?(evaluator)}
    end

    false
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children = []
    following_mark = @next_mover_mark == :x ? :o : :x
    @board.empty_positions.each do |pos|
      next_board = @board.dup
      next_board[pos] = @next_mover_mark
      children << TicTacToeNode.new(next_board, following_mark, pos)
    end
    children
  end
end