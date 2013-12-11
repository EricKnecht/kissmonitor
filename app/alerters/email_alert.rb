module KissMonitor
  class EmailAlert < MetricAlerter


    def initialize config
      super
      smtp_server   = option('smtp_server')
      smtp_port     = option('smtp_port')
      smtp_user     = option('smtp_user')
      smtp_password = option('smtp_password')
      smtp_domain   = option('smtp_domain')
      
      Mail.defaults do
        delivery_method :smtp, {
          :address => smtp_server,
          :port => smtp_port,
          :user_name => smtp_user,
          :password => smtp_password,
          :domain => smtp_domain,
          :authentication => :plain,
          :enable_starttls_auto => true
        }
      end
    end

    def send! alert
      subject = pretty_alert_msg alert
      body = <<-EOM #{alert.plugin_name}: #{alert.metric_name} has exceeded the threshold value of #{alert.threshold_value}
        Current Value: #{alert.current_value}
        Time: #{alert.start_time}
      EOM

      to_address = option('to_email')
      from_address = option('smtp_user')
      Mail.deliver do
        to to_address
        from from_address
        subject subject
        body body
      end
    end
  end
end