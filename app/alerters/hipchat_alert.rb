module KissMonitor
  class HipChatAlert < MetricAlerter

    def initialize config
      super
      @client = HipChat::Client.new(option('api_token'))
    end

    def send! alert
      msg = pretty_alert_msg alert
      client[option('room')].send(option('username'), msg)
    end

  end
end
