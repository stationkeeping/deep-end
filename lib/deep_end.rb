require "deep_end/version"

module DeepEnd

  class SelfDependencyError < StandardError; end
  class CircularDependencyError < StandardError; end
  
  class Node

    attr_reader :key
    attr_accessor :seen
    attr_reader :edges
    attr_accessor :dependee

    def initialize(key)
      @key = key
      @edges = []
    end

    def addEdge(node)
      @edges << node
    end 
    
  end

  class Graph

    def resolved_dependencies
      a = []
      @resolved.each{|node| a << node.key}
      return a
    end 

    def initialize
      reset
    end

    # Add a new node, causing dependencies to be re-evaluated
    def add_dependency(key, dependencies = [])

      raise SelfDependencyError, "An object's dependencies cannot contain itself" if dependencies.include? key

      node = node_for_key_or_new key
      dependencies.each do |dependency|
        node.addEdge(node_for_key_or_new(dependency))
      end
      resolve_dependencies
    end

    def reset
       @resolved = []
      @seen_this_pass
      @nodes = []
    end

    protected

      def resolve_dependencies
        reset_seen
        @resolved = []
        @nodes.each do |node| 
          @seen_this_pass = []
          resolve_dependency node unless node.seen
        end
      end

      # Recurse through node edges
      def resolve_dependency(node)
        node.seen = true
        @seen_this_pass << node
        
        node.edges.each do |edge| 
          unless @resolved.include? edge 
            unless @seen_this_pass.include? edge
              unless edge.seen
                resolve_dependency edge
              end
            else
              raise CircularDependencyError, "Circular reference detected: #{node.key.to_s} - #{edge.key.to_s}"
            end
          end
        end

        @resolved << node
      end
      
      def key_exists(key)
        return node_for_key(key).present?
      end

      def node_for_key(key)
        @nodes.each do |node|
          if node.key == key
            return node
          end
        end
        return 
      end

      def node_for_key_or_new(key)
        existing_node = node_for_key(key)
        if existing_node
          return existing_node
        else
          node = Node.new(key)
          @nodes << node
          return node
        end
      end

      def reset_seen
        @nodes.each do |node| 
          node.seen = false
        end
      end

  end
end