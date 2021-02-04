module ValetTasks
  module Model
    class Mysql

    attr_reader :database, :username, :password, :prefix, :host, :port

    def initialize(database:, username:, password:, prefix:, host:, port:)
      @database = database
      @username = username
      @password = password
      @prefix = prefix
      @host = host
      @port = port
    end

    def database_exists?
      hasDatabase = `mysql -u root -e "SHOW DATABASES LIKE '#{@database}'"`  
      hasDatabase == '' || hasDatabase == nil ? false : true
    end

    def user_exists?
      hasUser = `mysql -u root -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '#{@username}')"`
      hasUser.include?("0") ? false : true
    end

    def create_database
      system("mysql -u root -e \"CREATE DATABASE #{@database}\"")
    end

    def create_user
      system("mysql -u root -e \"CREATE USER '#{@username}'@'#{@host}' IDENTIFIED BY '#{@password}'\"")
    end

    def import_sql(sql)
      system("mysql -u root -h #{@host} #{@database} < #{sql}")
    end

    def grant_user_database
      system("mysql -u root -e \"GRANT ALL ON #{@database}.* TO '#{@username}'@'#{@host}';FLUSH PRIVILEGES;\"") 
      end
    end
  end
end