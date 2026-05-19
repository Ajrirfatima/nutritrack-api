FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-05-19 16:11:24" }
  end
end
