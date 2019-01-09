module Fwk
  module MigrationExpand
    def self.included(base)
      base.class_eval do

        def create_migration_file
          set_local_assigns!
          validate_file_name!

          path = File.join(db_migrate_path, "#{file_name}.rb")
          path = File.join("#{get_module}",db_migrate_path, "#{file_name}.rb") if get_module.present?
          migration_template @migration_template, path
        end

      end
    end
  end
end
