# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: 'User', email: 'user@user.com', password: '123123', daily_goal: 1)
Day.create!(date: Date.current, reviewed: 6, learned: 1, user: user)
Day.create!(date: Date.current - 1, reviewed: 4, learned: 2, user: user)
Day.create!(date: Date.current - 2, reviewed: 6, learned: 1, user: user)
Day.create!(date: Date.current - 3, reviewed: 1, learned: 0, user: user)
Day.create!(date: Date.current - 4, reviewed: 0, learned: 0, user: user)
Day.create!(date: Date.current - 5, reviewed: 0, learned: 0, user: user)
