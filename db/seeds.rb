# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "管理者",
  email: "admin@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  employee_number: 11111,
  uid: 123,
  admin:     true,
  )

  User.create!(name:  "上長１",
  email: "sv1@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  employee_number: 11111,
  uid:124,
  superior:     true,
  )

  User.create!(name:  "上長2",
  email: "sv2@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  employee_number: 11112,
  uid:125,
  superior:     true,
  )

  User.create!(name:  "上長3",
  email: "sv3@gmail.org",
  password:              "password",
  password_confirmation: "password",
  employee_number: 11113,
  uid:126,
  affiliation: "本社",
  superior:     true,
  )

  59.times do |n|
    name  = Faker::Name.name
    email = "email#{n+1}@sample.com"
    password = "password"
    User.create!(name:  name,
                email: email,
                affiliation: "本社",
                employee_number: n+1,
                uid: n+1,
                employee_number: 100000+n,
                password:              password,
                password_confirmation: password)
    end