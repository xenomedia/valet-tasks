module ValetTasks
  module Task
    include Rake::DSL if defined? Rake::DSL
    
    class Db < ::Rake::TaskLib
      def initialize
        super

        desc 'Database Commands'
        namespace :db do
          desc 'Create Local Project Mysql Database.'
          task :create_database do
            mysql = ValetTasks::Service::MysqlDatabaseCreator.run          
          end   

          desc 'Get Latest Database'
          task :get do
            dir = ValetTasks::Service::DatabaseBackup::DIRECTORY
            Dir.mkdir(dir) unless Dir.exist?(dir)
            ValetTasks::Model::GitIgnore.apend_to_file(dir)
            mysql = ValetTasks::Service::MysqlEnv.get
            db_backup = ValetTasks::Service::DatabaseBackup.new(file_name: ENV['DB_BACKUP_NAME'], extension: ENV['DB_BACKUP_FILE_EXTENSION'], server_path: ENV['DB_BACKUP_PATH'], gpg_key: ENV['GPG_KEY'], pantheon_site_name: ENV['PANTHEON_SITE_NAME'], pantheon_site_env: ENV['PANTHEON_SITE_ENV'])
            db_backup.get_database
          end

          desc 'Import Database'
          task :import do
            ARGV.each { |a| task a.to_sym do ; end }

            file = ARGV[1] ? ARGV[1] : "#{ValetTasks::Service::DatabaseBackup::DIRECTORY}/#{ENV['DB_BACKUP_NAME']}.sql"
            mysql = ValetTasks::Service::MysqlEnv.get
            mysql.import_sql file
          end

          desc 'Refresh Database'
          task :refresh do
            Rake::Task["db:get"].invoke
            Rake::Task["db:import"].invoke
          end
        end
      end
    end
  end
end

ValetTasks::Task::Db.new
