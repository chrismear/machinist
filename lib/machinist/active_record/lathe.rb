module Machinist::ActiveRecord

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args) #:nodoc:
      if block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else
        make_association(attribute, args)
      end
    end

    def make_association(attribute, args) #:nodoc:
      association = @klass.reflect_on_association(attribute)
      if association
        association.klass.make(*args)
      else
        raise_argument_error(attribute)
      end
    end
    
    def method_missing(attribute, *args, &block) #:nodoc:
      # Don't overwrite existing associations that the
      # object has been instantiated with.
      if object.class.reflect_on_association(attribute)
        association_object = (object.send(attribute))
        if association_object.respond_to?(:empty?)
          return unless association_object.empty?
        else
          return unless association_object.nil?
        end
      end
        
      unless attribute_assigned?(attribute)
        assign_attribute(attribute, make_attribute(attribute, args, &block))
      end
    end

  end
end
