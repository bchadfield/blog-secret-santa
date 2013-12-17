namespace :alert do
	desc "Send users countdown alert emails"
	task :countdown, [:view,:subject,:email] => :environment do |t, args|
		if args.email == "all"
			puts "Sending to all"
			User.available.each do |user|
    		UserMailer.countdown_alert(user, args.view, args.subject).deliver
    	end
    else
    	puts "Sending to #{args.email}"
    	user = User.find_by(email: args.email)
    	UserMailer.countdown_alert(user, args.view, args.subject).deliver
    end
	end
end