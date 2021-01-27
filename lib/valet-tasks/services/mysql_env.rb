module ValetTasks
  module Service
    class MysqlEnv
      def self.get
        ValetTasks::Model::Mysql.new(database: ENV['DB_DATABASE'], username: ENV['DB_USERNAME'], password: ENV['DB_PASSWORD'], prefix: ENV['DB_PREFIX'], host: ENV['DB_HOST'], port: ENV['DB_PORT']) 
      end
    end
  end
end