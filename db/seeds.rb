# frozen_string_literal: true

user = User.create!({
  email: "aegon@fugu.lol",
  password: "iloveghost12", 
  password_confirmation: "iloveghost12",
  status: "active"
})

project = Project.create(name: "fun-project", user: user)
project.create_api_keys

random_times = [
  1.hour.ago,
  1.day.ago,
  2.days.ago,
  3.days.ago,
  4.days.ago,
  5.days.ago,
  6.days.ago,
  7.days.ago,
  9.days.ago,
  11.days.ago,
  12.days.ago,
  13.days.ago,
  15.days.ago,
  16.days.ago
]

def create_event(name, properties, created_at, project)
  event = Event.create!({
    name: name,
    api_key: [project.api_key_live, project.api_key_test].sample,
    properties: properties
  })
  event.update(created_at: created_at)
end

# Event: Single Event
create_event(
  "Single Event",
  nil,
  1.hour.ago,
  project
)

# Event: Visited Landing Page
50.times do
  create_event(
    "Visited Landing Page",
    {
      country: "Germany",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

40.times do
  create_event(
    "Visited Landing Page",
    {
      country: "Switzerland",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

34.times do
  create_event(
    "Visited Landing Page",
    {
      country: "Germany",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

20.times do
  create_event(
    "Visited Landing Page",
    {
      country: "Switzerland",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

# Event: Clicked Payment Button
10.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Germany",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

8.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Switzerland",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

11.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Germany",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

6.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Switzerland",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

# Event: Clicked Payment Button
10.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Germany",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

8.times do
  create_event(
    "Clicked Payment Button",
    {
      country: "Switzerland",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

# Event: Paid successfully
5.times do
  create_event(
    "Paid successfully",
    {
      country: "Germany",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

2.times do
  create_event(
    "Paid successfully",
    {
      country: "Switzerland",
      platform: "mobile"
    },
    random_times.sample,
    project
  )
end

3.times do
  create_event(
    "Paid successfully",
    {
      country: "Germany",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

2.times do
  create_event(
    "Paid successfully",
    {
      country: "Switzerland",
      platform: "web"
    },
    random_times.sample,
    project
  )
end

# Event: Clicked on Settings Menu
20.times do
  create_event(
    "Clicked on Settings Menu",
    {
      country: "Switzerland",
      platform: "web",
      from: "main"
    },
    random_times.sample,
    project
  )
end

# Event: A lot of prop values
huge_props_values = [
  "Germany",
  "Switzerland",
  "Italy",
  "Spain",
  "Belgium",
  "The Netherlands",
  "Iceland",
  "USA",
  "Peru",
  "Mexico",
  "Guatemala",
  "Canda",
  "Chile",
  "Japan",
  "New Zealand",
  "Australia",
  "Singapore",
  "South Africa",
  "Ghana",
  "Ethiopia",
  "Eritrea",
  "Cote d'Ivoire",
  "Morocco",
  "Egypt",
  "Saudi Arabia",
  "Thailand",
  "South Korea",
  "Russia",
  "China"
]

huge_props_values.each do |pv|
  10.times.to_a.sample.times do
    create_event(
      "A lot of prop values",
      {
        country: pv,
        platform: "web"
      },
      random_times.sample,
      project
    )
  end
end
