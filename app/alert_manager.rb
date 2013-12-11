module KissMonitor
  class AlertManager < PluginManager

    def initialize config
      @alert_plugins = instantiate_plugins config
      super
    end

    #This method sends alerts only once
    #No one likes alert spam
    def send_alerts! alerts
      alerts.each do |alert|
        #Skip sending alerts if 
        #we have sent them before for this alert
        unless alert.alerts_sent and !alert.ended?
          @alert_plugins.map { |alerter| alerter.send! alert}
          alert.alerts_sent = true
          alert.save
        end
        alert.clear if alert.ended?
      end
    end
  end
end