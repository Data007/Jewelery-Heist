desc 'This description describes the task below it'
task sample: :environment do
  puts 'You can write any ruby in here.'
end

namespace :sample_namespace do
  desc 'You can also place things in a namespace'
  task sample: :environment do
    puts "You also have access to rails environmental variables like Rails.env: #{Rails.env}"
  end
end
