FactoryBot.define do
  factory :task do
    sequence(:title, "aaaaa")
    content { "aaaaaaa" }
    status { :todo }
    deadline { 1.week.from_now } 
    association :user
  end
end
