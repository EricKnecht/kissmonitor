module KissMonitor
  class StatsDMonitor < MetricShipper

    def initialize config
      super
      @statsd = Statsd.new option('statsd_server'), option('statsd_port')
    end

    def ship metrics
      metrics.each do |key, value|
        statsd_key = "#{hostname}::#{key}"
        @statsd.gauge statsd_key, value
      end
    end

  end
end