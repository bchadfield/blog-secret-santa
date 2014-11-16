# Group.delete_all
# User.delete_all
# Match.delete_all

# group1 = Group.find_by(subdomain: "first-group")
# group2 = Group.find_by(subdomain: "second-group")
# group1 = Group.create(name: "First group", subdomain: "first-group")
# group2 = Group.create(name: "Second group", subdomain: "second-group")
# User.create([{group_id: group1.id, name: "Bill", email: "bill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group1.id, name: "Frank", email: "frank@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group1.id, name: "Jill", email: "jill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group1.id, name: "Ben", email: "ben@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group1.id, name: "Wendy", email: "wendy@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group1.id, name: "Gill", email: "gill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Peter", email: "peter@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Nigel", email: "nigel@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Frances", email: "frances@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Jill", email: "jill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Jane", email: "jane@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{group_id: group2.id, name: "Sara", email: "sara@csworkflow.com", blog: "http://twitter.com/benchadfield"}])
# Group.update_all(status: 0)
# Group.create_matches

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