require 'rubygems'
require 'socket'
require 'active_support/all'
require 'vagrant'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), 'vagrant_tests'))

require 'vagrant_tests/environment_generator'
require 'vagrant_tests/dsl'

module VagrantTests
  # To change this template use File | Settings | File Templates.
end