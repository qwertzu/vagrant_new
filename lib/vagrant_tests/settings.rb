class Settings < Settingslogic
  source File.expand_path(File.dirname(__FILE__) + '/../../config/application.yml')
  namespace ENV['RAILS_ENV'] ? ENV['RAILS_ENV'] : ENV['RACK_ENV'] || 'vagrant'
  load!
end