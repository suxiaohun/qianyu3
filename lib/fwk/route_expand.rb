module Fwk
  module RouteExpand
    def self.included(base)
      base.class_eval do

        def add_resource_route
          return if options[:actions].present?

          depth = 0
          lines = []

          # Create 'namespace' ladder
          # namespace :foo do
          #   namespace :bar do
          regular_class_path.each do |ns|
            lines << indent("namespace :#{ns} do\n", depth * 2)
            depth += 1
          end

          # inserts the primary resource
          # Create route
          #     resources 'products'
          lines << indent(%{resources :#{file_name.pluralize}\n}, depth * 2)

          # Create `end` ladder
          #   end
          # end
          until depth.zero?
            depth -= 1
            lines << indent("end\n", depth * 2)
          end

          route lines.join
        end

      end
    end


  end
end