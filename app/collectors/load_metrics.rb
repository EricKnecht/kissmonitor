module KissMonitor 
  #collects free space information for all mount points (in MB)
  class LoadMetrics < MetricCollector
     DARWIN_UNITS = { "b" => 1/(1024*1024),
            "k" => 1/1024,
            "m" => 1,
            "g" => 1024 }

    #borrowed from Scout memory plugin
    #https://github.com/scoutapp/scout-plugins/blob/master/memory_profiler/memory_profiler.rb
    def collect
      load_avg = Sys::CPU.load_avg
      metrics['load_avg'] = load_avg[1] #use the 5m avg 

      if OS.mac?
        metrics['mem_usage'] = mac_mem_usage
      elsif OS.linux?
         metrics['mem_usage'] = linux_mem_usage
      else
        puts "UNKNOWN OS, Can't collect memory usage"
      end
      super
    end

    def linux_mem_usage
      mem_info = {}
        `cat /proc/meminfo`.each_line do |line|
          _, key, value = *line.match(/^(\w+):\s+(\d+)\s/)
          mem_info[key] = value.to_i
      end
      mem_total = mem_info['MemTotal'] / 1024
      mem_free = (mem_info['MemFree'] + mem_info['Buffers'] + mem_info['Cached']) / 1024
      mem_used = mem_total - mem_free
      (mem_percent_used = mem_used / mem_total.to_f * 100).to_i
    end


    # Percentage of mem used
    def mac_mem_usage
      mem_data = Hash.new
      top_output = `top -l1 -n0 -u`
      mem = top_output[/^(?:Phys)?Mem:.+/i]
      
      mem.scan(/(\d+|\d+\.\d+)([bkmg])\s+(\w+)/i) do |amount, unit, label|
        case label
        when 'used'
          mem_data[:used] =
          (amount.to_f * DARWIN_UNITS[unit.downcase]).round
        when 'free', 'unused'
          mem_data[:available] =
          (amount.to_f * DARWIN_UNITS[unit.downcase]).round
        end
      end
      total = mem_data[:used]+mem_data[:available]
      ((mem_data[:used].to_f/total)*100).to_i
    end

  end
end