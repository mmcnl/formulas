require './app'

namespace :db do

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate "db/"
  end

  desc "Rollback the database"
  task :rollback do
    ActiveRecord::Migrator.down "db/"
  end

  desc "Reset the database"
  task :reset do
    ActiveRecord::Migrator.down "db/"
    ActiveRecord::Migrator.migrate "db/"
  end

end
