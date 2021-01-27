# frozen_string_literal: true

require 'dotenv/load'
require 'rake'
require 'rake/tasklib'

require_relative "valet-tasks/version"

require_relative 'valet-tasks/models/env_file'
require_relative 'valet-tasks/models/mysql'
require_relative 'valet-tasks/models/git_ignore'

require_relative 'valet-tasks/services/database_credentials_asker'
require_relative 'valet-tasks/services/database_backup'
require_relative 'valet-tasks/services/gpg'
require_relative 'valet-tasks/services/mysql_env'
require_relative 'valet-tasks/services/mysql_database_creator'

require_relative 'valet-tasks/commands/laravel'
require_relative 'valet-tasks/commands/db'


module ValetTasks
  class Error < StandardError; end
  # Your code goes here...
end
