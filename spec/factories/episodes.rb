# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :episode do
    name "MyString"
    description "MyText"
    notes "MyText"
    published_at "2013-05-24 20:31:51"
    published false
    transcode_required false
  end
end
