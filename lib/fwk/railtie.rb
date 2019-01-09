require_relative 'generator_expand'
require_relative 'route_expand'
require_relative 'route_action_expand'
require_relative 'scaffold_expand'
require_relative 'scaffold_controller_expand'

require_relative 'model_expand'
require_relative 'controller_expand'
require_relative 'erb_controller_expand'
require_relative 'migration_expand'

module Fwk
  class Railtie < Rails::Railtie

    generators do

      # 扩展generator基础模块
      Rails::Generators::NamedBase.send(:include, Fwk::GeneratorExpand)

      # 1.扩展rails generate scaffold=>routes
      require 'rails/generators/rails/resource_route/resource_route_generator'
      Rails::Generators::ResourceRouteGenerator.send(:include, Fwk::RouteExpand)
      require 'rails/generators/actions'
      Rails::Generators::Actions.send(:include, Fwk::RouteActionExpand)


      # 扩展rails generate scaffold=>views
      require 'rails/generators/erb/scaffold/scaffold_generator'
      Erb::Generators::ScaffoldGenerator.send(:include, Fwk::ScaffoldExpand)

      # 扩展rails generate scaffold=>controller
      require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'
      Rails::Generators::ScaffoldControllerGenerator.send(:include, Fwk::ScaffoldControllerExpand)


      # 扩展rails generate model=>model and migration (注：scaffold指令会invoke此模块用于生成model以及migration)
      require 'rails/generators/active_record/model/model_generator'
      ActiveRecord::Generators::ModelGenerator.send(:include, Fwk::ModelExpand)


      # 1.扩展rails generate controller=>controller
      require 'rails/generators/rails/controller/controller_generator'
      Rails::Generators::ControllerGenerator.send(:include, Fwk::ControllerExpand)
      # 2.扩展rails generate controller=>views
      require 'rails/generators/erb/controller/controller_generator'
      Erb::Generators::ControllerGenerator.send(:include, Fwk::ErbControllerExpand)

      # 扩展rails generate migration=>migration
      require 'rails/generators/active_record/migration/migration_generator'
      ActiveRecord::Generators::MigrationGenerator.send(:include, Fwk::MigrationExpand)


    end
  end
end