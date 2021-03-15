# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

["GPU", "CPU", "peripherals", "monitors", "motherboards", "PSU", "RAM", "SSD", "HDD"].each do |cat|
  Category.create(name: cat)
end