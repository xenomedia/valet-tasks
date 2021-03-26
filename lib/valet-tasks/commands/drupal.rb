module ValetTasks
  module Task
    include Rake::DSL if defined? Rake::DSL
    
    class Drupal < ::Rake::TaskLib
      def initialize
        super

        desc 'Drupal'
        namespace :drupal do
          desc 'Drupal Initial Setup - Runs all the commands for setting up project for development.'
          task :setup do
            Rake::Task["drupal:create_env_file"].invoke
            Rake::Task["drupal:update_env_file"].invoke
            self.update_env
            Rake::Task["db:create_database"].invoke
            self.update_env
            Rake::Task["db:get"].invoke
            self.update_env
            Rake::Task["db:import"].invoke
            self.update_env
            Rake::Task["drupal:create_settings"].invoke
          end

          desc 'Drupal create environment file.'
          task :create_env_file do
          	system 'rake env:create_env_file .env2'
      	  end

      	  desc 'Drupal update Environment file variables.'
          task :update_env_file do
          	system 'rake env:update_env_file .env2'
          end

          desc 'Create Drupal Settings'
          task :create_settings do

            settings_file = 'web/sites/default/settings.local.php'
            default_settings_file = 'web/sites/example.settings.local.php'
            change_log = 'web/CHANGELOG.txt'

            if (File.exist?(change_log) and File.readlines(change_log).grep(/Drupal 7./).any?)
              settings_file = 'web/sites/default/local.settings.php'
              default_settings_file = 'web/sites/default/default.local.settings.php'
            end

            if (File.exist?(settings_file))
              abort("Settings already exists.")
              next
            end

            if (!File.exist?(default_settings_file))
              abort("web/sites/example.settings.local.php could not be found.")
              next
            end

            settings_to_add = "

      			$databases['default']['default'] = [
      			  'database' => '#{ENV['DB_DATABASE']}',
      			  'username' => '#{ENV['DB_USERNAME']}',
      			  'password' => '#{ENV['DB_PASSWORD']}',
      			  'host' => '#{ENV['DB_HOST']}',
      			  'port' => '#{ENV['DB_PORT']}',
      			  'prefix' => '#{ENV['DB_PREFIX']}',
      			  'driver' => 'mysql',
                    'collation' => 'utf8mb4_general_ci',
      			];

      			$settings['hash_salt'] = '123456';
      			"

      			FileUtils.cp_r("./#{default_settings_file}", "./#{settings_file}")
      			File.write(settings_file, settings_to_add, mode: 'a')

      			puts "Settings file has been created."
          end 
        end
      end

      def update_env
        Dotenv.overload('.env2')
      end
    end
  end
end

ValetTasks::Task::Drupal.new
