class ModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  attr_reader :module_name, :module_path


  # first, the initialize method

  def initialize(args,*options)
    super
    full_name = file_name.underscore

    @module_name = full_name.split('_').last
    @module_path = 'modules/' + full_name

  end





  # When a generator is invoked, each public method in the generator
  # is executed sequentially in the order that it is defined


  def create_files

    # remove_dir('modules') # todo remove the dirs to test
    empty_directory('modules') unless Dir.exist?('modules')

    empty_directory "#{module_path}"
    empty_directory "#{module_path}/app"
    empty_directory "#{module_path}/app/controllers"
    empty_directory "#{module_path}/app/models"
    empty_directory "#{module_path}/app/helpers"
    empty_directory "#{module_path}/app/views"
    empty_directory "#{module_path}/config"
    empty_directory "#{module_path}/config/initializers"
    empty_directory "#{module_path}/config/locals"
    empty_directory "#{module_path}/db"
    empty_directory "#{module_path}/db/migrate"
    empty_directory "#{module_path}/lib"


    copy_file 'routes.rb', "#{module_path}/config/routes.rb" # 路由文件

  end









end
