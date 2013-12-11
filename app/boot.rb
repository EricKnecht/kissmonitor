KISSM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) 
APP_ROOT = "#{KISSM_ROOT}/app"

require "#{APP_ROOT}/plugin"
require "#{APP_ROOT}/plugin_manager"
require "#{APP_ROOT}/alert"
require "#{APP_ROOT}/alert_manager"
require "#{APP_ROOT}/launcher"
require "#{APP_ROOT}/metric_shipping_manager"
['metric_alerter', 'metric_collector', 'metric_shipper'].each { |file| require "#{APP_ROOT}/#{file}" }
Dir["#{APP_ROOT}/alerters/*.rb"].each {|file| require file }
Dir["#{APP_ROOT}/collectors/*.rb"].each {|file| require file }
Dir["#{APP_ROOT}/shippers/*.rb"].each {|file| require file }

#Function to do debug logging
def debug string
  puts string if $DEBUG
end

