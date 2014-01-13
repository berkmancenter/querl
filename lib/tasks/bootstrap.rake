namespace :querl do
  desc "Add the default admin"
  task :default_admin => :environment do
    user = User.new(:username => 'admin', :email => 'admin@example.com')
    if %w[development test dev local].include?(Rails.env)
      user.password = "12345678"
    else
      user.password = User.random_password
    end
    user.save
    puts "Admin username is: #{user.username}"
    puts "Admin password is: #{user.password}"
  end
end  