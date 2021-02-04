module ValetTasks
  module Model
    class GitIgnore
      def self.apend_to_file(text)
        File.write(".gitignore", "\n#{text}", mode: 'a') unless File.readlines('.gitignore').grep(/#{text}/).any?
      end
    end
  end
end