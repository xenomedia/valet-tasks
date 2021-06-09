module ValetTasks
  module Service
    class DatabaseBackup
      DIRECTORY = 'db_backup'

      def initialize(file_name:, extension:, server_path:, gpg_key:, pantheon_site_name:, pantheon_site_env:)
        @file_name = file_name
        @extension = extension
        @server_path = server_path
        @gpg_key = gpg_key
        @pantheon_site_name = pantheon_site_name
        @pantheon_site_env = pantheon_site_env

        @file = "#{@file_name}.#{@extension}"
        @server_backup_path = "#{@server_path}/#{@file}"
        @local_file_path = "#{DIRECTORY}/#{@file}"
      end

      def get_database
        if self.is_pantheon?
          terminus = ValetTasks::Service::Terminus.new(site_name: @pantheon_site_name, env: @pantheon_site_env)
          terminus.backup_create
          terminus.backup_get(@local_file_path)
        else
          puts "scp db_backup:#{@server_backup_path} #{@local_file_path}"
          system("scp db_backup:#{@server_backup_path} #{@local_file_path}")
          self.unarchive
        end
      end

      def unarchive
        case @extension
        when 'sql.gpg'
          system("gpg --yes --ignore-mdc-error --batch --passphrase=#{@gpg_key} #{@local_file_path}")
          system("rm #{@local_file_path}")
        when 'sql.gz'
          system("gunzip -f #{@local_file_path}")
        end
      end

      private

      def is_pantheon?
        @pantheon_site_name ? true : false
      end
    end
  end
end