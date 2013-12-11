module KissMonitor
  class MetricAlerter < Plugin

    def pretty_alert_msg alert
      unless alert.ended?
         "#{alert.plugin_name}: #{alert.metric_name} on #{hostname} exceeded #{alert.threshold_value}, current value: #{alert.current_value}"  
      else 
         "#{alert.plugin_name}: #{alert.metric_name} on #{hostname} back to normal" 
      end
    end
  end
end