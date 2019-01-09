module Fwk
  module ModelExpand
    def self.included(base)
      base.class_eval do

        def create_migration_file
          return if (options[:migration]==false || options[:parent].present?)
          attributes.each { |a| a.attr_options.delete(:index) if a.reference? && !a.has_index? } if options[:indexes] == false

          # File.join('','db','migrate')=> '/db/migrate'  ##wrong,permission deny
          # File.join(db','migrate')=> 'db/migrate' ##right

          path = File.join(db_migrate_path, "create_#{table_name}.rb")
          path = File.join(get_module,db_migrate_path, "create_#{table_name}.rb") if get_module.present?

          migration_template "../../migration/templates/create_table_migration.rb", path
        end

        def create_model_file
          template "model.rb", File.join("#{get_module}app/models", class_path, "#{file_name}.rb")
        end

      end
    end
  end
end
