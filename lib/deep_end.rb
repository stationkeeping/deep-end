require "deep_end/version"

module DeepEnd
  # Errors
  class SelfDependencyError < StandardError; end
  class CircularDependencyError < StandardError; end

  # Graph Node
  class Node

    attr_reader :key
    attr_accessor :seen
    alias_method :seen?, :seen
    attr_reader :edges
    attr_reader :resolved_dependencies

    def initialize(key)
      @key = key
      @edges = []
    end

    def addEdge(node)
      @edges << node
    end

  end

  # Dependency Graph
  class Graph

    def resolved_dependencies
      @resolved.map{|node| node.key}
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

    # Return the graph to its virgin state
    def reset
      @resolved = []
      @nodes = []
    end

    protected

    # Recurse through nodes
    def resolve_dependencies
      puts "NODES: "+@nodes.inspect
      reset_seen
      @resolved = []
      @nodes.each do |node|
        @seen_this_pass = []
        puts "RESOLVED: "+@resolved.inspect
        resolve_dependency node unless node.seen?
      end
      @resolved
    end

    # Recurse through node edges
    def resolve_dependency(node)
      node.seen = true
      @seen_this_pass << node

      puts "EDGES: "+ node.edges.inspect
      node.edges.each do |edge|
        unless @resolved.include? edge
          unless @seen_this_pass.include? edge
            unless edge.seen?
              resolve_dependency edge
            end
          else
            raise CircularDependencyError, "Circular reference detected: #{node.key.to_s} - #{edge.key.to_s}"
          end
        end
      end
      @resolved << node
    end

    def node_for_key(key)
      @nodes.each { |node| return node if node.key == key }
      return
    end

    def node_for_key_or_new(key)
      node_for_key(key) || (@nodes << Node.new(key)).last
    end

    def reset_seen
      @nodes.each{ |node| node.seen = false}
    end

  end
end
