module ValetTasks
  module Service
    class MysqlDatabaseCreator
      def self.run
        mysql = ValetTasks::Service::MysqlEnv.get       
	    if (mysql.database_exists?)
	      puts "#{mysql.database} database already exists and it has not been created."
	    else
	      mysql.create_database
	      puts "#{mysql.database} database has been created."
	    end

	    if (mysql.user_exists?)
	      puts "#{mysql.username} user already exists and it has not been created."
	    else
	      mysql.create_user
	      mysql.grant_user_database
	      puts "#{mysql.username} user has been created and added to #{mysql.database} database."
	    end
      end
    end
  end
end
