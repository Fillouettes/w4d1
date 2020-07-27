class PolyTreeNode

attr_reader :children, :parent, :value 

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def parent=(node)
      if !node
         @parent = nil
      end
      if @parent != nil && @parent.children.include?(self)
         @parent.children.delete(self) 
      end
      @parent = node 
      if node
         if !node.children.include?(self)
            node.children << self
         end
      end
    end

    def inspect
      @value
    end

    def add_child(child_node)
        child_node.parent = self
        if !@children.include?(child_node)
            @children << child_node
        end
    end

    def remove_child(child_node)
        raise "Not a child" if !@children.include?(child_node)
        child_node.parent = nil
        @children.delete(child_node)
    end

    def dfs(target_value)
        return self if target_value == @value
        found = nil
        @children.each do |child|
            found ||= child.dfs(target_value)
        end

        found
    end

    def bfs(target_value) #node instance method, use case: node.bfs(value)
      results = []
      results << self
      while !results.empty?
         current = results.shift
         if current.value == target_value
            return current
         end
         current.children.each do |child|
            results << child
         end
      end
      nil
    end
end
