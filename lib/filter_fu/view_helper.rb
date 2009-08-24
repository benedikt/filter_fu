require 'ostruct'

module FilterFu
  module ViewHelper
    
    def self.included(base)
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      
      def filter_form_for(*args, &block)
        raise ArgumentError, 'Missing block' unless block_given?
        
        opts = args.extract_options!
        name = (args.first || :filter).to_sym
        
        opts[:ignore_parameters] ||= []
        opts[:ignore_parameters] += [:controller, :action, name]
        
        opts[:html] ||= {}
        opts[:html][:method] ||= :get
                
        form_for(name, OpenStruct.new(params[name]), opts) do |f|
          hidden_fields_for(params, opts)
          block.call(f)
        end
      end
      
      private
      
      def hidden_fields_for(params, opts, prefix = nil)
        params.each_pair do |k, v| 
          next if opts[:ignore_parameters].include?(k.to_sym)
          
          k = "[#{k}]" if prefix
          
          if v.kind_of?(Hash)
            hidden_fields_for(v, opts, "#{prefix}#{k}")
          else 
            concat(hidden_field_tag("#{prefix}#{k}", v)) 
          end
        end
      end
      
    end
    
  end
end