require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "",
                                     email: "foobar@invalid",
                                     password: "foo",
                                     password_confirmation: "bar" }}
    assert_template 'users/edit'
    assert_select "div.alert", "The form contain4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert session[:forwarding_url].nil?
    name = "FooBar"
    email = "FooBaar@foobar.com"
    patch user_path(@user), params: { user: { name: name,
                                        email: email,
                                        password: "",
                                        password_confirmation: "" }}
    assert_not flash.empty?
    assert_redirected_to user_path(@user)
    @user.reload
    assert_equal name, @user.name
    assert_equal email.downcase, @user.email
  end
end
