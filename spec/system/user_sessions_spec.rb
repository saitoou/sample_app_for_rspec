require 'rails_helper'

RSpec.describe "UserSessions", type: :system do

  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'test'
      click_button 'Login'
      expect(page).to have_content 'Login successful' 
      end
    end

    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
      visit login_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: 'test'
      click_button 'Login'
      expect(page).to have_content 'Login failed'
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
      login_as(user)
      click_link 'Logout'
      expect(page).to have_content 'Logged out'
      end
    end
  end
end
