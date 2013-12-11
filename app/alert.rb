require 'dbm'
require 'json'
module KissMonitor
  class Alert < Hashie::Mash

    @@db = DBM.open("/tmp/kissm_alerts", 0666, DBM::WRCREAT)

    def self.find plugin_name, metric_name
      alert = @@db["#{plugin_name}::#{metric_name}"]
      alert ? self.new(JSON.parse(alert)) : nil
    end

    def db
      @@db
    end

    def ended?
      status == :ended
    end

    def key
      "#{plugin_name}::#{metric_name}"
    end

    def save 
      unless db.has_key? key
        self.status = :started
        self.start_time = Time.now
      end
      db[key] = self.to_json
    end

    def clear
      db.delete key
    end

  end
end