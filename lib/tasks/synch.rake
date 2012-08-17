namespace :sync do
  desc 'Sync production to local'
  task local: :environment do
    server_string = `heroku config | grep MONGOHQ_URL`.split('=>')[1].strip
    # mongodb://wexfordj:datacare@locke.mongohq.com:10058/wexford-data-node1
    server = {}
    server[:host] = server_string.match(/^.*:\/\/.+:.+@(.+):/).captures[0]
    server[:port] = server_string.match(/^.*:\/\/.+:(.*)\//).captures[0]
    server[:user] = server_string.match(/^.*:\/\/(\w+):/).captures[0]
    server[:pass] = server_string.match(/^.*:\/\/\w+:(\w+)@/).captures[0]
    server[:db]   = server_string.match(/^.*\/(.*)/).captures[0]

    puts "[sync:local] #{server_string} ... Starting"
    
    tmp_dir = Rails.root.join('tmp', 'sync').to_s
    FileUtils.mkdir_p tmp_dir unless Dir.exists?(tmp_dir)

    system "mongodump --verbose --host #{server[:host]}:#{server[:port]} --username #{server[:user]} --password #{server[:pass]} --db #{server[:db]} --out #{tmp_dir}"

    system "mongorestore --verbose --host localhost --db dragon_hoard_development #{File.join(tmp_dir, server[:db]).to_s}"

    puts "[sync:local] #{server_string} ... Done"
  end
end
