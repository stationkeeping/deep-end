require 'spec_helper'

module DeepEnd
  
  describe Graph do

    before(:each) do
      @graph = Graph.new
    end

    context 'when first created' do 
      it 'should have no resolved dependencies' do
        @graph.resolved_dependencies.should be_empty
      end
    end

    context 'when given dendencies' do 

      # Create dependencies
      before(:each) do
        @dependency_a = {name: 'a'}
        @dependency_b = {name: 'b'}
        @dependency_c = {name: 'c'}
        @dependency_d = {name: 'd'}
        @dependency_e = {name: 'e'}
      end

      it 'should not be empty' do
        @graph.add_dependency @dependency_a
        sorted_objects = @graph.resolved_dependencies.should_not be_empty
      end

      it 'should contain the dependency' do
        @graph.add_dependency @dependency_a
        sorted_objects = @graph.resolved_dependencies.should include(@dependency_a)
      end

      it 'should maintain order of non-interdependent objects' do
        # Add dependencies
        @graph.add_dependency @dependency_a
        @graph.add_dependency @dependency_b
        @graph.add_dependency @dependency_c
        # Check order
        sorted_objects = @graph.resolved_dependencies
        sorted_objects[0].should == @dependency_a
        sorted_objects[1].should == @dependency_b
        sorted_objects[2].should == @dependency_c
      end

      it 'should correctly order interdependent objects' do
        # Add dependencies
        @graph.add_dependency @dependency_c, [@dependency_b, @dependency_a]
        @graph.add_dependency @dependency_b, [@dependency_a]
        @graph.add_dependency @dependency_a
        # Check order
        sorted_objects = @graph.resolved_dependencies
        sorted_objects[0].should == @dependency_a
        sorted_objects[1].should == @dependency_b
        sorted_objects[2].should == @dependency_c
      end

      it 'should raise a SelfDependencyError if an object is added as its own dependency' do
        # Add dependencies
        expect { @graph.add_dependency @dependency_a, [@dependency_a] }.to raise_error(SelfDependencyError) 
      end

      it 'should raise a CircularDependencyError if objects are added with direct circular dependencies' do
        # Add dependencies
        @graph.add_dependency @dependency_b, [@dependency_a]
        expect { @graph.add_dependency @dependency_a, [@dependency_b] }.to raise_error(CircularDependencyError) 
      end

      it 'should raise a CircularDependencyError if objects are added with indirect circular dependencies' do
        # Add dependencies
        @graph.add_dependency @dependency_b, [@dependency_c]
        @graph.add_dependency @dependency_c, [@dependency_a]
        expect { @graph.add_dependency @dependency_a, [@dependency_b] }.to raise_error(CircularDependencyError) 
      end

      context "when reset" do 

        it 'should have no resolved dependencies' do
          # Add dependencies
          @graph.add_dependency @dependency_c, [@dependency_b, @dependency_a]
          @graph.add_dependency @dependency_b, [@dependency_a]
          @graph.add_dependency @dependency_a
          @graph.reset 
          @graph.resolved_dependencies.length.should == 0
        end
      end

    end
  end
end