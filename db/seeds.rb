# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: 'User', email: 'user@user.com', password: '123123', daily_goal: 9)
reviewed = Measure.create!(name: 'Reviewed')
learned = Measure.create!(name: 'Learned')

day1 = Day.create!(date: Date.current, user: user)
day2 = Day.create!(date: Date.current - 1, user: user)
day3 = Day.create!(date: Date.current - 2, user: user)
day4 = Day.create!(date: Date.current - 3, user: user)
day5 = Day.create!(date: Date.current - 4, user: user)
Day.create!(date: Date.current - 5, user: user)

Measurement.create!(day: day1, measure: reviewed, amount: 4)
Measurement.create!(day: day1, measure: learned, amount: 2)
Measurement.create!(day: day2, measure: learned, amount: 10)
Measurement.create!(day: day3, measure: reviewed, amount: 11)
Measurement.create!(day: day4, measure: learned, amount: 3)
Measurement.create!(day: day4, measure: reviewed, amount: 5)
Measurement.create!(day: day5, measure: learned, amount: 7)
Measurement.create!(day: day5, measure: reviewed, amount: 1)
