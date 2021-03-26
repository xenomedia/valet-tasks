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
            Rake::Task["env:create_env_file"].invoke
            Rake::Task["env:update_env_file"].invoke
            self.update_env
            Rake::Task["db:create_database"].invoke
            self.update_env
            Rake::Task["db:get"].invoke
            self.update_env
            Rake::Task["db:import"].invoke
          end  
        end

        desc 'Laravel create environment file.'
        task :create_env_file do
          Rake::Task["env:create_env_file"].invoke
        end

        desc 'Laravel update Environment file variables.'
        task :update_env_file do
          Rake::Task["env:update_env_file"].invoke
        end
      end

      def update_env
        Dotenv.overload('.env')
      end
    end
  end
end

ValetTasks::Task::Laravel.new
