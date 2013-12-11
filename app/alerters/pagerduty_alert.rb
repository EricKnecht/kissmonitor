module KissMonitor
  class PagerdutyAlert < MetricAlerter

    def initialize config
      super
      @client = Pagerduty.new option('service_key')
    end

    def send! alert
      unless alert.ended?
        subject = pretty_alert_msg alert
        incident = @client.trigger subject
        alert.metadata[:pagerduty_id] = incident.id
        alert.save
      else
        pagerduty_id = alert.metadata[:pagerduty_id]
        incident = @client.get_incident pagerduty_id
        incident.resolve
      end
    end

  end
end
