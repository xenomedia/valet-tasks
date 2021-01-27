module ValetTasks
  module Task
    include Rake::DSL if defined? Rake::DSL
    
    class Laravel < ::Rake::TaskLib
      def initialize
        super

        desc 'Laravel'
        namespace :laravel do
          desc 'Laravel Initial Setup - Runs all the commands for setting up project for development.'
          task :setup do
            Rake::Task["laravel:create_env_file"].invoke
            Rake::Task["laravel:update_env_file"].invoke
            Rake::Task["laravel:create_database"].invoke
            Rake::Task["db:get"].invoke
            Rake::Task["db:import"].invoke
          end

          desc 'Create Laravel Environment File'
          task :create_env_file do
            if (File.exist?('.env'))
              abort("Environment file already exists.")
              next
            end

            default_env_file_name = '.env.example'
            env_file_name = '.env'
            if (File.exist?(default_env_file_name))
              require 'fileutils'
              FileUtils.cp_r("./#{default_env_file_name}", "./#{env_file_name}")
              ValetTasks::Model::GitIgnore.apend_to_file('.env')
              puts "#{env_file_name} has been created."
            end
          end

          desc 'Update Environment file variables.'
          task :update_env_file do
            databaseCredentialsAsker = ValetTasks::Service::DatabaseCredentialsAsker.new
            {
              'DB_DATABASE' => databaseCredentialsAsker.database,
              'DB_USERNAME' => databaseCredentialsAsker.username,
              'DB_PASSWORD' => databaseCredentialsAsker.password,
              'DB_PREFIX' => databaseCredentialsAsker.prefix,
              'DB_PORT' => databaseCredentialsAsker.port,
              'DB_HOST' => databaseCredentialsAsker.host,
            }.each do | variable, value|
              ValetTasks::Model::EnvFile.update_variable('.env', variable, value)
            end
            ValetTasks::Service::Gpg.set_key_if_needed
          end 

          desc 'Create Local Project Mysql Database.'
          task :create_database do
            mysql = ValetTasks::Service::MysqlDatabaseCreator.run          
          end    
        end
      end
    end
  end
end

ValetTasks::Task::Laravel.new
