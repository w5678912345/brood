module Features
  module SessionHelpers
    def sign_up_with(user)
      visit new_user_session_path
      visit "sign_in"
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on '登 录'
    end

    def sign_in
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on '登 录'
    end
    def sign_out
    end
  end
end