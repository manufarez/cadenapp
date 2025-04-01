require "rails_helper"

RSpec.describe Invitation, type: :model do
  let(:cadena) { build(:cadena) }
  let(:user) { build(:user) }
  let(:invitation) { build(:invitation, cadena: cadena, sender: user) }

  it "is valid with valid attributes" do
    expect(invitation).to be_valid
  end

  it "is not valid without a phone number" do
    invitation.phone = nil
    expect(invitation).to_not be_valid
  end

  it "is not valid without a cadena" do
    invitation.cadena = nil
    expect(invitation).to_not be_valid
  end

  it "is not valid without an email" do
    invitation.email = nil
    expect(invitation).to_not be_valid
  end

  it "is not valid without a first name" do
    invitation.first_name = nil
    expect(invitation).to_not be_valid
  end

  it "is not valid without a last name" do
    invitation.last_name = nil
    expect(invitation).to_not be_valid
  end
end
