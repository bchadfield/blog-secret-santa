# Pool.delete_all
# User.delete_all
Match.delete_all

pool1 = Pool.find_by(subdomain: "first-pool")
pool2 = Pool.find_by(subdomain: "second-pool")
# pool1 = Pool.create(name: "First pool", subdomain: "first-pool")
# pool2 = Pool.create(name: "Second pool", subdomain: "second-pool")
# User.create([{pool_id: pool1.id, name: "Bill", email: "bill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool1.id, name: "Frank", email: "frank@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool1.id, name: "Jill", email: "jill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool1.id, name: "Ben", email: "ben@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool1.id, name: "Wendy", email: "wendy@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool1.id, name: "Gill", email: "gill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Peter", email: "peter@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Nigel", email: "nigel@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Frances", email: "frances@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Jill", email: "jill@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Jane", email: "jane@csworkflow.com", blog: "http://twitter.com/benchadfield"},
# 							{pool_id: pool2.id, name: "Sara", email: "sara@csworkflow.com", blog: "http://twitter.com/benchadfield"}])
Pool.update_all(status: 0)
# Pool.create_matches

# Pool.all.each do |pool|
# 	users = User.where(pool: pool)
# 	matches = loop do
# 	  shuffled = users.shuffle.zip(users.shuffle)
# 	  break shuffled if shuffled.index { |x,y| x == y } == nil
# 	end
# 	matches.each do |match|
# 		giver = match[0]
# 		receiver = match[1]
# 		Match.create(pool: pool, giver: giver, receiver: receiver)
# 	end
# end