require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


require "./lib/fwk/railtie"



module Qianyu
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.


    # 1.If you want to change Rails timezone, but continue to have Active Record save in the database in UTC,use
    config.time_zone = 'Beijing'

    # 2.If you want to change Rails timezone AND have Active Record store times in this timezone,
    # config.active_record.default_timezone = :local

    # 根据编码顺序加载自定义模块文件


    module_total_dirs = Dir::entries('modules') - %w('.','..')

    # todo 另：此处以后可以加入白名单机制，只加载白名单内key对应的文件
    module_white_dirs = module_total_dirs

    module_white_dirs.each do |v|
      config.paths.keys.each do |key|
        next unless config.paths[key].to_ary.is_a?(Array)
        file_path = "modules/#{v}/#{key}"
        real_file_path = "#{config.root}/#{file_path}"

        if File.exist?(real_file_path)
          next if key == 'config/database'
          # @paths.unshift(*paths)
          config.paths[key].unshift(file_path)
        end
      end
    end



    config.generators do |g|
      # g.orm :active_record
      # g.template_engine :erb
      g.test_framework nil # 禁止自动生成单元测试文件
      # g.system_tests nil # 禁止生自动成单元测试文件
      # g.resource_route  false # 禁止自动生成路由
      # g.helper true # 禁止自动生成helper
      g.assets false # 禁止自动生成assets
    end


  end
end
