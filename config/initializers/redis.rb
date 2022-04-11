$redis = Redis::Namespace.new("Instabug_API_Challenge", :redis => Redis.new(:host => "redis"))
