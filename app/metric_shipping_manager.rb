module KissMonitor
  class MetricShippingManager < PluginManager

    def initialize config
      @shippers = instantiate_plugins config
      super
    end

    def ship metrics
      @shippers.each {|plugin| plugin.ship metrics}
    end

  end
end