require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.system { Faker::Company.catch_phrase }

Feature.blueprint do
  name { Sham.system }
end

Chore.blueprint do
  name { Sham.system }
end

Bug.blueprint do
  name { Sham.system + " not working" }
end
