module ValetTasks
  module Service
    class DatabaseCredentialsAsker
      attr_reader :username, :password, :database, :prefix, :host, :port

      def initialize
        @database = default_name
        @username = default_name
        @password = default_name
        @prefix = ''
        @host = 'localhost'
        @port = '3306'

        ask_for_database_info
      end

      def default_name
        File.basename(Dir.pwd)
      end

      def ask_for_database_info
        [
          'database',
          'username',
          'password',
          'prefix',
          'host',
          'port',
        ].each do |value|
          ask_question(value)
        end
      end

      def ask_question(key)
        puts "What is the: #{key}? If left blank `#{instance_variable_get("@#{key}")}` will be used."
        STDOUT.flush
        input = STDIN.gets.chomp
        instance_variable_set("@#{key}", input) unless input == ''
      end
    end
  end
end