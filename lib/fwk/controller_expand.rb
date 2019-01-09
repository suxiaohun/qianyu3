module Fwk
  module ControllerExpand
    def self.included(base)
      base.class_eval do

        source_root File.expand_path('../../templates/controller', __FILE__)


        # 自定义后，application.rb中的配置失效了，需要移除hook
        remove_hook_for  :helper, :assets

        def create_controller_files
          template "controller.rb", File.join("#{get_module}app/controllers", class_path, "#{file_name}_controller.rb")
        end

      end
    end
  end
end
