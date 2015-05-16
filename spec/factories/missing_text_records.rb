require 'faker'

FactoryGirl.define do
  factory :missing_text_record, :class => 'MissingText::Record' do
    parent_dir { |n| Faker::Lorem.words(5).join("/")}
    files     [{lang: "en", type: ".yml", path: "#{Faker::Lorem.words(5).join('/')}/en.yml"}, {lang: "fr", type: ".yml", path: "#{Faker::Lorem.words(5).join('/')}/fr.yml"}]
    missing_text_batch_id { FactoryGirl.create(:missing_text_batch).id }
  end

end
