module ValetTasks
  module Service
    class Terminus
      def initialize(site_name:, env:)
        @site_name = site_name
        @env = env
      end

      def backup_create
        puts("terminus backup:create #{@site_name}.#{@env} --element=db")
        system("terminus backup:create #{@site_name}.#{@env} --element=db")
      end

      def backup_get(save_location)
        system("terminus backup:get #{@site_name}.#{@env} --element=db --to=#{save_location}")
        system("gunzip #{save_location}")
      end
    end
  end
end