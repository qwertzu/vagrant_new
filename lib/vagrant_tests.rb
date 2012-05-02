require 'rubygems'
require 'socket'
require 'active_support/all'
require 'vagrant'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), 'vagrant_tests'))

require 'vagrant_tests/configgen'
require 'vagrant_tests/foo3'
require 'vagrant_tests/test_helper'

module VagrantTests
  # To change this template use File | Settings | File Templates.
end