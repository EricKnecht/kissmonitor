require 'sys/filesystem'
module KissMonitor 
  #collects free space information for all mount points (in MB)
  class DiskMetrics < MetricCollector

    def collect
      Sys::Filesystem.mounts.each do |mount|
        mount_stats = Sys::Filesystem.stat(mount.mount_point)
        blocks_used = mount_stats.blocks - mount_stats.blocks_free
        percent_used = blocks_used.to_f / mount_stats.blocks
        metrics[mount.mount_point] = percent_used * 100
      end
      super
    end
  end
end