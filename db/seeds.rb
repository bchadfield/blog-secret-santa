draw = Draw.create(match_time: Time.utc(2013,11,20,14,00,00), gift_time: Time.utc(2013,12,12,14,00,00), status: "open")
User.create([{name: "Bill", email: "bill@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Frank", email: "frank@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Jill", email: "jill@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Ben", email: "ben@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Wendy", email: "wendy@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Gill", email: "gill@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Peter", email: "peter@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Nigel", email: "nigel@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Frances", email: "frances@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Jill", email: "jill@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Jane", email: "jane@csworkflow.com", url: "http://twitter.com/benchadfield"},
							{name: "Sara", email: "sara@csworkflow.com", url: "http://twitter.com/benchadfield"}])
User.all.each do |user|
	Content.create(draw_id: draw.id, user_id: user.id, title: "This is by #{user.name} #{user.id}", body: "Body of the content by #{user.name}")
end