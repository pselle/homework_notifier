ENV["REDISTOGO_URL"] ||= "redis://localhost:8379/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)