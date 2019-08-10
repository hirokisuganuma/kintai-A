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
  admin:     true,
  )

  User.create!(name:  "上長１",
  email: "sv1@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  sv:     true,
  )

  User.create!(name:  "上長2",
  email: "sv2@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  sv:     true,
  )

  User.create!(name:  "上長3",
  email: "sv3@gmail.org",
  password:              "password",
  password_confirmation: "password",
  affiliation: "本社",
  sv:     true,
  )

  59.times do |n|
    name  = Faker::Name.name
    email = "email#{n+1}@sample.com"
    password = "password"
    User.create!(name:  name,
                email: email,
                affiliation: "本社",
                worker_number: n+1,
                card_id: n+1,
                password:              password,
                password_confirmation: password)
    end