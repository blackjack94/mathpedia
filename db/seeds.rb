# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
khoa = User.create(username: 'blackjack94', password: '123456', password_confirmation: '123456',
																					  school: 'FPT University', admin: true, master: true, status: 1)
puts "#{khoa.username} created!"

Domain.create(name: 'Đại Số')
Domain.create(name: 'Hình Học')
Domain.create(name: 'Giải Tích')
Domain.create(name: 'Số Học')
Domain.create(name: 'Tổ Hợp')

puts "#{Domain.count} domains created!"