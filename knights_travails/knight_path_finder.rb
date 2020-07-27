require_relative "./00_tree_node.rb"

class KnightPathFinder

    attr_reader :current_leaves

    def self.valid_moves?(position)
        if position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0
            return false
        end
        true
    end

    def initialize(initial_position)
        @initial_position = initial_position
        @root_node = PolyTreeNode.new(initial_position)
        @considered_positions = [initial_position.dup]
        @current_leaves = [@root_node]
    end

    def new_move_positions(pos)
      y = pos[0]
      x = pos[1]
      next_possible_moves = []
      next_possible_moves << [y - 2, x + 1]  
      next_possible_moves << [y - 2, x - 1]

      next_possible_moves << [y + 2, x - 1]
      next_possible_moves << [y + 2, x + 1]

      next_possible_moves << [y + 1, x + 2]
      next_possible_moves << [y + 1, x - 2]
      
      next_possible_moves << [y - 1, x - 2]
      next_possible_moves << [y - 1, x + 2]

      next_possible_moves.reject! { |position| !KnightPathFinder.valid_moves?(position) || @considered_positions.include?(position) }

      @considered_positions += next_possible_moves

      next_possible_moves
    end

    def build_move_tree  #this will add one level deeper nodes to our current tree
        length = @current_leaves.length  #current_leaves holds the bottom layer of our tree
        length.times do   #we only want to pop our current layer off of our queue; we are building the next layer as we go
            leaf = @current_leaves.shift
            positions = new_move_positions(leaf.value)
            positions.each do |pos|
                leaf.add_child(PolyTreeNode.new(pos))
            end
            @current_leaves += leaf.children
        end
    end

    #until we find our target
    #we bfs our tree
    #then add a level using create next moves
    #then we return_path for the node that contains our target
    def find_path(end_pos)
      found = nil 
      until found
         found ||= @root_node.bfs(end_pos)
         self.build_move_tree
      end
      p trace_path_back(found)
    end


    def trace_path_back(node)
        results = []
        current = node
        until current == @root_node
            results.unshift(current.value) #add current position to the front of our array
            current = current.parent       #then move one level up in our tree
        end
        results.unshift(current.value)
        results
    end
    
end

# kpf = KnightPathFinder.new([0, 0])
# kpf.find_path([2, 1]) # => [[0, 0], [2, 1]]
# kpf.find_path([3, 3]) # => [[0, 0], [2, 1], [3, 3]]

kpf = KnightPathFinder.new([0, 0])
kpf.find_path([2, 1]) # => [[0, 0], [2, 1]]
kpf.find_path([3, 3]) # => [[0, 0], [2, 1], [3, 3]
kpf.find_path([7, 7])