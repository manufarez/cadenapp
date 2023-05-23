require "application_system_test_case"

class InvitationsTest < ApplicationSystemTestCase
  setup do
    @invitation = invitations(:one)
  end

  test "visiting the index" do
    visit invitations_url
    assert_selector "h1", text: "Invitations"
  end

  test "should create invitation" do
    visit invitations_url
    click_on "New invitation"

    check "Accepted" if @invitation.accepted
    fill_in "Cadena", with: @invitation.cadena_id
    fill_in "First name", with: @invitation.first_name
    fill_in "Last name", with: @invitation.last_name
    fill_in "Phone", with: @invitation.phone
    click_on "Create Invitation"

    assert_text "Invitation was successfully created"
    click_on "Back"
  end

  test "should update Invitation" do
    visit invitation_url(@invitation)
    click_on "Edit this invitation", match: :first

    check "Accepted" if @invitation.accepted
    fill_in "Cadena", with: @invitation.cadena_id
    fill_in "First name", with: @invitation.first_name
    fill_in "Last name", with: @invitation.last_name
    fill_in "Phone", with: @invitation.phone
    click_on "Update Invitation"

    assert_text "Invitation was successfully updated"
    click_on "Back"
  end

  test "should destroy Invitation" do
    visit invitation_url(@invitation)
    click_on "Destroy this invitation", match: :first

    assert_text "Invitation was successfully destroyed"
  end
end
