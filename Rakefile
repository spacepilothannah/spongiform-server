require 'spongiform/db'

namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task :lint do
    require 'factory_bot'
    require 'database_cleaner'
    require 'faker'
    Dir[__dir__+'/spec/factories/*.rb'].each {|rb| require rb }

    DatabaseCleaner.cleaning do
      FactoryBot.lint
    end
  end
end
