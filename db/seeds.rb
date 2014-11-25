# Group.delete_all
# User.delete_all
# Match.delete_all
# Content.delete_all

# Group.create([{name: "Content Strategy", slug: "contentstrategy", status: 0},
# 							{name: "UX", slug: "ux", status: 0},
# 							{name: "Reading", slug: "reading", status: 0},
# 							{name: "Technology", slug: "technology", status: 0},
# 							{name: "Cricket", slug: "cricket", status: 0},
# 							{name: "Food", slug: "food", status: 0}])

# group_ids = Group.all.map(&:id)

# 100.times do
# 	uri = URI.parse("http://api.randomuser.me")
# 	http = Net::HTTP.new(uri.host, uri.port)
# 	request = Net::HTTP::Get.new(uri.request_uri)
# 	response = http.request(request)
# 	user = JSON.parse(response.body)["results"][0]["user"]
# 	User.create(group_id: group_ids.sample, 
# 							name: "#{user['name']['first'].capitalize} #{user['name']['last'].capitalize}", 
# 							email: user["email"],
# 							blog: "http://#{user["email"][/\.(.*?)@/, 1]}.com",
# 							password: user["password"],
# 							password_confirmation: user["password"])
# end

20.times do
	uri = URI.parse("http://api.randomuser.me")
	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	user = JSON.parse(response.body)["results"][0]["user"]
	User.create(email: user["email"],
							password: user["password"],
							password_confirmation: user["password"])
end

# Group.all.each do |group|
# 	users = User.where(group: group)
# 	matches = loop do
# 	  shuffled = users.shuffle.zip(users.shuffle)
# 	  break shuffled if shuffled.index { |x,y| x == y } == nil
# 	end
# 	matches.each do |match|
# 		giver = match[0]
# 		receiver = match[1]
# 		Match.create(group: group, giver: giver, receiver: receiver)
# 	end
# end