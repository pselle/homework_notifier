desc "Called by cron, sends out scheduled text messages on the hour"
task :cron=>:environment do
  worker=Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY'], :quiet => false)
  while job=Delayed::Job.reserve(worker)
    worker.run(job)
  end
end
