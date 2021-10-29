users = [{:email_id => 'test1@columbia.edu', :name => 'test1 user'},
    {:email_id => 'test2@columbia.edu', :name => 'test2 user'},
    {:email_id => 'test3@columbia.edu', :name => 'test3 user'},
 ]

users.each do |user|
    User.create!(user)
end