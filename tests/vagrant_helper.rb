require 'bundler'
Bundler.require

require File.expand_path(File.dirname(__FILE__) + './../lib/vagrant_tests')

Dir[File.join(File.dirname(__FILE__) + '/../startup/', '*.rb')].each do |f|
  require f
end