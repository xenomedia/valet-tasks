module ValetTasks
  module Model
    class EnvFile
      def self.update_variable(file_name, variable, value)
        file = File.read(file_name)
        updated_line = file.gsub(/^.*#{Regexp.quote("#{variable}=")}.*$/, "#{variable}=#{value}")
        File.open(file_name, 'w') { |line| line.puts updated_line }
        Dotenv.overload(file_name)
      end
    end
  end
end