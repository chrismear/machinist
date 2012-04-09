module Machinist::ActiveRecord
  class Blueprint < Machinist::Blueprint
    
    def make(attributes = {}, association_collection=nil)
      lathe = lathe_class.new((association_collection || @klass), new_serial_number, attributes)

      lathe.instance_eval(&@block)
      each_ancestor {|blueprint| lathe.instance_eval(&blueprint.block) }

      lathe.object
    end

    # Make and save an object.
    def make!(attributes = {}, association_collection=nil)
      object = make(attributes, association_collection)
      object.save!
      object.reload
    end

    def lathe_class #:nodoc:
      Machinist::ActiveRecord::Lathe
    end

  end
end
