require 'socket'
module KissMonitor
  class Plugin

    attr_accessor :config

    def initialize config
      @config = config
    end

    def option name
      @config[name] || ENV["KISSM_#{plugin_name}_#{name}"]
    end

    def plugin_name
      self.class.name.split('::').last || ''
    end

    def hostname
      Socket.gethostname
    end

  end
end