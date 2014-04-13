require 'faker'

5.times do
  password = Faker::Lorem.characters(10)
  user = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password)
  user.skip_confirmation!
  user.save

  # Note: by calling `User.new` instead of `create`,
  #   # we create an instance of a user which isn't saved to the database.
  #     # The `skip_confirmation!` method sets the confirmation date
  #       # to avoid sending an email. The `save` method updates the database.

  5.times do
    post = Post.create(
      user: user,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph)
    #set the created_at to a time within the past year
      post.update_attribute(:created_at, Time.now - rand(600..31536000))
  end
end

user = User.first
user.skip_reconfirmation!
user.update_attributes(email: 'eric87chen@gmail.com', password: 'jesus', password_confirmation: 'jesus')

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
