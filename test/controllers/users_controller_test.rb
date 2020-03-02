require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @certificate_authority = FactoryBot.create(:certificate_authority)
    @user = FactoryBot.create(:user, id: 1)
    @user.certificate_authorities << @certificate_authority
  end

  test "should get index" do
    get :index, certificate_authority_id: @certificate_authority.id
    assert_response :success
  end

  test "should get grant" do
    get :grant, certificate_authority_id: @certificate_authority.id, id: @user.id
    assert_response :success
  end

  test "should get revoke" do
    get :revoke, certificate_authority_id: @certificate_authority.id, id: @user.id
    assert_response :success
  end

end
