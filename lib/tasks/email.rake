desc 'Removing Multiple emails from each user, and just having 1 email'
task one_email: :environment do
  User.all.each do |user|
    if user.email == nil
      user.email = user.emails.first
      user.emails = []
    else
      user.emails = []
    end
  end
end
