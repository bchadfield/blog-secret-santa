every "0 0 05 12 *" do
  runner "Group.create_matches"
end

every "0 0 25 12 *" do
	runner "Group.give_gifts"
end