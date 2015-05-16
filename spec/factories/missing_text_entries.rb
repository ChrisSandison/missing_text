require 'faker'

FactoryGirl.define do
  factory :missing_text_entry, :class => 'MissingText::Entry' do
    missing_text_records_id { FactoryGirl.create(:missing_text_record)}
    base_language  { ["en", "fr", "es"].sample }
    base_string    { |n| Faker::Lorem.sentence }
    target_languages { ["en", "fr", "es"].sample(rand(1..2))}
    locale_code { |n| Faker::Lorem.words(rand(3..5)).join(".") }
  end

end
