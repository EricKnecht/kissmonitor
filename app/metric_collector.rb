Dir["collectors/*.rb"].each {|file| require file }
module KissMonitor
  class MetricCollector < Plugin

    COMPARATORS = [:>, :<, :>=, :<=, :==]

    attr_accessor :metrics, :alerts
    def initialize config
      @alerts = []
      @metrics = {}
      super
    end

    def collect
      check_alert_thresholds
    end

    def check_alert_thresholds
      alert_thresholds = option('alert_thresholds')
      metrics.each do |key, value| 
        if alert_thresholds.has_key? key and alert_thresholds[key]
          threshold_value = alert_thresholds[key]['value']
          theshold_type = alert_thresholds[key]['type'].to_sym
          next unless COMPARATORS.include? theshold_type
          alert = Alert.find plugin_name, key
          #if metric comparison is true, create/update an alert


          if value.send(theshold_type, threshold_value)
            if alert
              alert.current_value = value
            else 
              alert = Alert.new
              alert.plugin_name = plugin_name
              alert.metric_name = key
              alert.threshold_value = threshold_value
              alert.current_value = value
            end
            alert.save
            alerts << alert
          #if metric comparison is false, clear alert
          elsif alert
            alert.status = :ended
            alert.save
            alerts << alert
          end
        end 
      end
    end

    def has_alerts?
      alerts.any?
    end
  end
end