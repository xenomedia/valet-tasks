module ValetTasks
  module Task
    include Rake::DSL if defined? Rake::DSL
    
    class Env < ::Rake::TaskLib
      def initialize
        super

        desc 'Env'
        namespace :env do
          desc 'Create environment file.'
          task :create_env_file do
            ARGV.each { |a| task a.to_sym do ; end }
            env_file = ARGV[1] ? ARGV[1] : '.env'

            if (File.exist?(env_file))
              abort("Environment file already exists.")
              next
            end

            default_env_file_name = "#{env_file}.example"
            if (File.exist?(default_env_file_name))
              require 'fileutils'
              FileUtils.cp_r("./#{default_env_file_name}", "./#{env_file}")
              ValetTasks::Model::GitIgnore.apend_to_file(env_file)
              puts "#{env_file} has been created."
            end
          end

          desc 'Update Environment file variables.'
          task :update_env_file do
            env_file = env_file_name
            databaseCredentialsAsker = ValetTasks::Service::DatabaseCredentialsAsker.new
            {
              'DB_DATABASE' => databaseCredentialsAsker.database,
              'DB_USERNAME' => databaseCredentialsAsker.username,
              'DB_PASSWORD' => databaseCredentialsAsker.password,
              'DB_PREFIX' => databaseCredentialsAsker.prefix,
              'DB_PORT' => databaseCredentialsAsker.port,
              'DB_HOST' => databaseCredentialsAsker.host,
            }.each do | variable, value|
              ValetTasks::Model::EnvFile.update_variable(env_file, variable, value)
            end
            ValetTasks::Service::Gpg.set_key_if_needed(env_file)
            self.set_database_backup
          end   
        end
      end

      def set_database_backup
        key = 'DB_BACKUP_NAME'
        puts "What is the: #{key}? If left blank `#{default_name}` will be used."
        STDOUT.flush
        input = STDIN.gets.chomp
        input = input != '' ? input : default_name
        ValetTasks::Model::EnvFile.update_variable(env_file_name, key, input)
      end

      def default_name
        File.basename(Dir.pwd)
      end

      def env_file_name
        env_file = ARGV[1] ? ARGV[1] : '.env'
      end
    end
  end
end

ValetTasks::Task::Env.new
