module Fwk
  module RouteActionExpand
    def self.included(base)
      base.class_eval do


        def route(routing_code)
          log :route, routing_code
          sentinel = /\.routes\.draw do\s*\n/m

          in_root do
            inject_into_file "#{get_module}config/routes.rb", "  #{routing_code}\n", after: sentinel, verbose: false, force: false
          end
        end



      end
    end


  end
end