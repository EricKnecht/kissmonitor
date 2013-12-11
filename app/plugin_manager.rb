module KissMonitor
  class PluginManager

    attr_accessor :config

    def initialize(config)
      @config = config
    end    

    def instantiate_plugins plugins_config
      if plugins_config
        plugins_config.map do |plugin_config|
          plugin_name = plugin_config['plugin']
          begin
            plugin = Object.const_get('KissMonitor').const_get plugin_name
          rescue
            puts "Unknown plugin: #{plugin_name}, skipping"
          end
          plugin.new(plugin_config)
        end
      else
        []
      end
    end
  end
end