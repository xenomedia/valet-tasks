module ValetTasks
  module Service
    class Gpg
      def self.set_key_if_needed(env_file)
        key = 'GPG_KEY'
        if ENV.key?(key)
          puts "What is the GPG key (This will be used for unarchiving the database backups in gpg format)?"
          STDOUT.flush
          value = STDIN.gets.chomp
          ValetTasks::Model::EnvFile.update_variable(env_file, key, value) unless value == ''
        end
      end
    end
  end
end