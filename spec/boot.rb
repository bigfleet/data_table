# Stolen outright from will_paginate

plugin_root = File.join(File.dirname(__FILE__), '..')

# simply use installed gems if available.  data_table's goal is max compatability

require 'rubygems'
  
gem 'actionpack'
gem 'activerecord'
gem 'activesupport'

$:.unshift "#{plugin_root}/lib"
