$disk_store = DiskStore.new(Rails.root.join('public', 'cache', 'favicons'), eviction_strategy: :LRU, cache_size: 100.megabytes, reaper_interval: 10.minutes)
