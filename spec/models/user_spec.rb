require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  before do
    user.save(validate: false)
  end

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "should have an attached avatar" do
    user.avatar.purge

    expect(user.avatar).not_to be_attached
  end

  it "should accept terms on update" do
    user.accepts_terms = false
    expect(user.valid?).to be false
  end

  it "is not valid without a phone number" do
    user.phone = nil
    expect(user).to_not be_valid
  end

  it "is not valid without an email" do
    user.email = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a first name" do
    user.first_name = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a last name" do
    user.last_name = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a identification_number" do
    user.identification_number = nil
    expect(user).to_not be_valid
  end
  it "is not valid without a identification_type" do
    user.identification_type = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a sex" do
    user.sex = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a dob" do
    user.dob = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user.password = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a address" do
    user.address = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a zip" do
    user.zip = nil
    expect(user).to_not be_valid
  end

  it "is not valid without a city" do
    user.city = nil
    expect(user).to_not be_valid
  end
end
