require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.system { Faker::Company.catch_phrase }

Story.blueprint do
  name { Sham.system }
end
