module ValetTasks
  module Task
    include Rake::DSL if defined? Rake::DSL

    class Wordpress < ::Rake::TaskLib
      def initialize
        super

        desc 'Wordpress'
        namespace :wordpress do
          desc 'Wordpress Initial Setup - Runs all the commands for setting up project for development.'
          task :setup do
            Rake::Task["wordpress:create_env_file"].invoke
            Rake::Task["wordpress:update_env_file"].invoke
            self.update_env
            Rake::Task["db:create_database"].invoke
            self.update_env
            Rake::Task["db:get"].invoke
            self.update_env
            Rake::Task["db:import"].invoke
            self.update_env
            Rake::Task["wordpress:create_config"].invoke
            self.update_env
            Rake::Task["wordpress:search_and_replace"].invoke
          end

          desc 'Wordpress create environment file.'
          task :create_env_file do
            system 'rake env:create_env_file .env2'
          end

          desc 'Wordpress update Environment file variables.'
          task :update_env_file do
            system 'rake env:update_env_file .env2'
          end

          desc 'Create Wordpress Config'
          task :create_config do

            config_file = 'web/wp-config.php'
            if (!File.exist?(config_file) and  File.exist?('web/wp-config-sample.php'))
              FileUtils.cp('web/wp-config-sample.php', config_file)
            end

            config_file = 'wp-config-local.php'
            if (File.exist?(config_file))
              abort("Config file already exists.")
              next
            end

            File.write(config_file, self.get_wordpress_config, mode: 'a')

            puts "Config file has been created."
          end

          desc 'Wordpress search and replace'
          task :search_and_replace do
            command = "wp search-replace '#{ENV['LIVE_URL']}' '#{self.get_local_url}' --skip-columns=guid"
            puts command
            if (File.exist?('web'))
                command.prepend("cd web && ")
            end

            system(command)
          end
        end
      end

      def get_local_url
        return "http://#{File.basename(Dir.getwd)}.test"
      end

      def update_env
        Dotenv.overload('.env2')
      end

      private

      def get_wordpress_config
        config = "<?php\n"
        config << "\n"
        config << "/** MySQL database name */\n"
        config << "define('DB_NAME', '#{ENV['DB_DATABASE']}');\n"
        config << "\n"
        config << "/** MySQL database username */\n"
        config << "define('DB_USER', '#{ENV['DB_USERNAME']}');\n"
        config << "\n"
        config << "/** MySQL database password */\n"
        config << "define('DB_PASSWORD', '#{ENV['DB_PASSWORD']}');\n"
        config << "\n"
        config << "/** MySQL database hostname */\n"
        config << "define('DB_HOST', '#{ENV['DB_HOST']}');\n"
        config << "\n"
      end
    end
  end
end

ValetTasks::Task::Wordpress.new
