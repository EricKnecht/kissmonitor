module KissMonitor
  class Launcher < PluginManager

    def initialize config
      @alert_manager = AlertManager.new config['metric_alerts']
      @ship_manager = MetricShippingManager.new config['metric_shippers']
      super
    end

    #Collects metrics, sends alerts, then ships metrics 
    def run
      collector_config = config['metric_collectors']
      metric_plugins = instantiate_plugins collector_config
      metric_plugins.each do |metric_collector|
        metric_collector.collect
        @alert_manager.send_alerts! metric_collector.alerts
        @ship_manager.ship metric_collector.metrics
      end
    end


  end
end