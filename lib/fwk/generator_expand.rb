module Fwk
  module GeneratorExpand
    def self.included(base)
      base.class_eval do
        class_option :module, type: :string, default: '',
                     desc: "自定义的模块参数"

        # 获取传递过来的参数判断是否含有module
        def get_module
          if options[:module].present?

            #todo 后期要追加启动参数判定,注意此处的w%不可用，使用[]
            module_dir = Dir::entries('modules') - ['.','..']

            module_hash = {}

            module_dir.each do |x|
              module_hash[x.split('_').last.to_sym] = x
            end

            full_name = module_hash[options[:module].to_sym]


            if full_name
              "modules/#{full_name}/"
            else
              raise "\e[31m\未定义#{options[:module]}模块，请核对module参数\e[0m"
            end
          else
            ''
          end

        end
      end
    end


  end
end