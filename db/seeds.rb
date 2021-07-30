# frozen_string_literal: true

user = User.create!({
  email: "aegon@fugu.lol",
  password: "iloveghost12", 
  password_confirmation: "iloveghost12"
})


project = Project.create(name: "Fun Project", user: user)

random_times = [
  1.hour.ago,
  1.day.ago,
  2.days.ago,
  3.days.ago,
  4.days.ago,
  5.days.ago,
  6.days.ago,
  7.days.ago,
]

for i in 0..50
   event = Event.create!({
    name: 'Visited Page 1',
    api_key: [project.api_key_live, project.api_key_test].sample,
    properties: %({
      "favorite_animal": "Donkey",
      "type": "Early user"
    })
  })
  event.update(created_at: random_times.sample)
end

for i in 0..40
   event = Event.create!({
    name: 'Visited Page 2',
    api_key: [project.api_key_live, project.api_key_test].sample,
    properties: %({
      "color": "Blue",
      "size": "12"
    })
  })
  event.update(created_at: random_times.sample)
end


for i in 0..30
   event = Event.create!({
    name: 'Visited Page 3',
    api_key: [project.api_key_live, project.api_key_test].sample,
    properties: %({
      "tree": "Oak",
      "width": "300"
    })
  })
  event.update(created_at: random_times.sample)
end