module Machinist
  module ActiveRecord
    # Alternative make/make! methods to be used on a has-many association:
    # 
    # <tt>post.comments.make!</tt>
    # 
    # A reference to the association is passed through to the blueprint. The
    # blueprint then instructs the lathe to build a new associated object
    # instead of a new instance of the base class (e.g.
    # <tt>post.comments.new</tt> instead of <tt>Comment.new</tt>).
    module MachinableAssociationCollection
      def make(*args)
        decode_args_to_make(*args) do |blueprint, attributes|
          blueprint.make(attributes, self)
        end
      end
      
      def make!(*args)
        decode_args_to_make(*args) do |blueprint, attributes|
          raise BlueprintCantSaveError.new(blueprint) unless blueprint.respond_to?(:make!)
          blueprint.make!(attributes, self)
        end
      end
    end
  end
end
