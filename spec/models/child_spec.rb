require "rails_helper"

RSpec.describe Child, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).only_integer.is_greater_than(0).is_less_than(18) }
    it { should validate_inclusion_of(:dietary_restriction).in_array(Child::DIETARY_RESTRICTIONS) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:meal_plans).dependent(:destroy) }
  end

  describe "#daily_calorie_goal" do
    it "returns 1200 for toddlers aged 1-3" do
      child = build(:child, age: 2)
      expect(child.daily_calorie_goal).to eq(1200)
    end

    it "returns 1500 for children aged 4-8" do
      child = build(:child, age: 6)
      expect(child.daily_calorie_goal).to eq(1500)
    end

    it "returns 1800 for children aged 9-13" do
      child = build(:child, age: 10)
      expect(child.daily_calorie_goal).to eq(1800)
    end

    it "returns 2000 for teenagers aged 14-17" do
      child = build(:child, age: 15)
      expect(child.daily_calorie_goal).to eq(2000)
    end
  end

  describe "scopes" do
    let!(:young_child) { create(:child, age: 3) }
    let!(:older_child) { create(:child, age: 10) }
    let!(:vegan_child) { create(:child, dietary_restriction: "vegan") }

    it "filters by age" do
      expect(Child.by_age(3)).to include(young_child)
      expect(Child.by_age(3)).not_to include(older_child)
    end

    it "filters by dietary restriction" do
      expect(Child.with_restriction("vegan")).to include(vegan_child)
    end
  end
end
