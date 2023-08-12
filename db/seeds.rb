user_amount = 5
puts "Creating users..."
user_amount.times do
    User.create(
        email: Faker::Internet.unique.email,
        password: Faker::Internet.password(min_length: 6),
        username: Faker::Internet.unique.username
    )
end

article_amount = 10
puts "Creating articles..."
article_amount.times do |num|
    Article.create(
        title: Faker::Creature::Cat.name,
        content: Faker::Lorem.paragraphs(number: 10).join(' '),
        image: Faker::LoremFlickr.image(size: "300x300", search_terms: ['cats']),
        user_id: num % 5 + 1
    )
end

comments_amount = 6
puts "Creating comments..."
article_amount.times do |article|
    comments_amount.times do |user|
        user = user % 6
        user = nil if user == 0
        Comment.create(
            content: Faker::Lorem.sentence,
            article_id: article % 10 + 1,
            user_id: user
        )
    end
end

puts "Creating reactions..."
article_amount.times do |article|
    user_amount.times do |user|
        Reaction.create(
            reaction_type: rand(2),
            article_id: article+1,
            user_id: user+1
        )
    end
end

puts "Creating admin..."
User.create(email: "admin@admin.com", password: "123456", username: "Admin", role: "admin")
