module Dependencies

end

# class TestObject
#   attr_reader :name
#   def initialize(name)
#     @name = name
#   end
# end

# class Test

#   include Dependencies

#   def initialize
#     @dependency_graph = Dependencies::Graph.new

#     a = TestObject.new("A");
#     b = TestObject.new("B");
#     c = TestObject.new("C");
#     d = TestObject.new("D");
#     e = TestObject.new("E");
#     f = TestObject.new("F");
#     g = TestObject.new("G");

#     @dependency_graph.add_dependency(a, [c,d])
#     @dependency_graph.add_dependency(b, [c,f])
#     @dependency_graph.add_dependency(f, [c,a])
#     @dependency_graph.add_dependency(e, [c,f])

#     @dependency_graph.resolved_dependencies.each{|node| puts "-> #{node.name}" }

#   end

# end

# Test.new
