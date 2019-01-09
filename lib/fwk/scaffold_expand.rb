module Fwk
  module ScaffoldExpand
    def self.included(base)
      base.class_eval do

        source_root File.expand_path('../../templates/views', __FILE__)


        # 扩展生成视图的文件夹
        def create_root_folder
          empty_directory File.join("#{get_module}app/views", controller_file_path)
        end


        def copy_view_files
          available_views.each do |view|
            formats.each do |format|
              filename = filename_with_extensions(view, format)
              template filename, File.join("#{get_module}app/views", controller_file_path, filename)
            end
          end
        end

        private

        def available_views
          %w(index edit new show _form)
        end
      end
    end


  end
end