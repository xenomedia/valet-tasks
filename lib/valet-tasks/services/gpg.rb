module ValetTasks
  module Service
    class Gpg
      def self.set_key_if_needed
        key = 'GPG_KEY'
        if ENV.key?(key)
          puts "What is the GPG key (This will be used for unarching the database backups in gpg format)?"
          STDOUT.flush
          value = STDIN.gets.chomp
          ValetTasks::Model::EnvFile.update_variable('.env', key, value) unless value == ''
        end
      end
    end
  end
end