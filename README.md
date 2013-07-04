# DeepEnd

This gem processes a list of objects and their dependencies, ordering them so that dependencies are correctly resolved and checking for circular dependencies.

## Installation

Add this line to your application's Gemfile:

    gem 'deep_end'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deep_end

## Usage

The Graph is the only class you have to worry about:

    dependency_graph = Graph.new

Add any objects you like to it, along with an array of any other objects that they depend on:
    
    # Create objects - you can use any objects/instances
    dependency_a = {name: 'a'}
    dependency_b = {name: 'b'}
    dependency_c = {name: 'c'}

    dependency_graph.add_dependency dependency_c, [dependency_b, dependency_a]
    dependency_graph.add_dependency dependency_b, [dependency_a]
    dependency_graph.add_dependency dependency_a

An array of all objects in an order that obeys dependencies is returned from 'add_dependency',
It is also available from the `resolved_dependencies` property.

    dependency_graph.resolved_dependencies # [{:name=>"a"}, {:name=>"b"}, {:name=>"c"}]

To reuse the Graph you can remove all objects and dependencies using `reset`:

    dependency_graph.reset

Whenever a new object is added with `add_dependency`, the graph re-calculates dependencies. An object can
be added multiple times with different dependencies. Dependencies are cumulative, so adding an object for
a second time with different dependencies will result in the object having both sets of dependencies.

If an object is added with itself as a dependency, a `SelfDependencyError` will be raised. 

If a circular dependency is detected a `CircularDependencyError` will be raise.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request