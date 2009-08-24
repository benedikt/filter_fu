module FilterFu
  module ActiveRecord
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      VALID_FILTER_OPTIONS = [:only, :except]
      
      def filter_fu(opts = {})
        opts = opts.symbolize_keys!
        opts.each_key { |option| raise "Invalid filter_fu option: #{option}" unless VALID_FILTER_OPTIONS.include?(option) }
        raise "Use either :only or :except as a filter_fu option." if opts.has_key?(:only) && opts.has_key?(:except)
        
        opts[:only]   = [opts[:only]].flatten.collect(&:to_sym) if opts[:only]
        opts[:except] = [opts[:except]].flatten.collect(&:to_sym) if opts[:except]
        
        @filter_options = opts
        
        extend SingletonMethods
      end
      
    end
    
    module SingletonMethods
      
      def filtered_by(filter)
        filter ||= {}
        filter.symbolize_keys!
        
        filter.inject(self) do |memo, (scope, arg)|
          next if protected?(scope)
          if scopes.has_key?(scope)
            memo.send(scope, arg)
          else
            memo.scoped(build_anonymous_scope(scope, arg))
          end
        end
      end
      
      private
      
      def build_anonymous_scope(scope, arg)
        return {} unless column_names.include?(scope.to_s) && !arg.blank?
        { :conditions => { scope => arg } }
      end
      
      def protected?(scope)
        if @filter_options.has_key?(:only)
          return !@filter_options[:only].include?(scope)
        elsif @filter_options.has_key?(:except)
          return @filter_options[:except].include?(scope)
        end
        return false
      end
      
    end
    
  end
end