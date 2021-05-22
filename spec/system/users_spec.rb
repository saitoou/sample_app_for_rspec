require 'rails_helper'

RSpec.describe "Users", type: :system do

  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザーの新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in 'Email', with: 'testa@example.com'
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'SignUp'
          expect(page).to have_content "User was successfully created."
          expect(current_path).to eq login_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'SignUp'
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済みのメールアドレス' do
        it 'ユーザーの新規作成が失敗する' do
          duplicated_user = create(:user)
          visit sign_up_path
          fill_in 'Email', with: duplicated_user.email
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'SignUp'
          expect(page).to have_content "Email has already been taken"
        end
      end

    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
        visit user_path(user)
        expect(page).to have_content "Login required"
        end
      end
    end

  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
        visit edit_user_path(user)
        fill_in 'Email', with: 'testb@example.com'
        fill_in 'Password', with: 'test'
        fill_in 'Password confirmation', with: 'test'
        click_button 'Update'
        expect(page).to have_content 'User was successfully updated.'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済みのメールアドレス' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          other_user = create(:user)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'test'
          fill_in 'Password confirmation', with: 'test'
          click_button 'Update'
          expect(page).to have_content 'Email has already been taken'
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        it '編集ページのアクセスが失敗する' do
          other_user = create(:user)
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access'
        end
      end

    end

    describe 'マイページ' do
      context 'タスクの作成' do
        it '新規作成のタスクが表示される' do
        create(:task, title: 'aaaaa', status: 'doing', user: user)
        visit user_path(user)
        expect(page).to have_content 'aaaaa'
        end
      end
    end

  end

end
