require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'タスクページにアクセス' do
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの編集ページにアクセス' do
        it '編集ページのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end

      context 'タスクの詳細ページにアクセスする' do
        it '詳細ページのアクセスが成功する' do
          visit task_path(task)
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タスクの一覧ページにアクセスする' do
        it '一覧ページにアクセスが成功する' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスク新規登録' do
      context 'フォームの入力値が正常' do
        it 'タスクの登録ができる' do
          visit new_task_path
          fill_in 'Title', with: 'aaaaa'
          fill_in 'Content', with: 'aaaaa'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021, 5, 19, 17, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Title: aaaaa'
          expect(page).to have_content 'Content: aaaaa'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2021/5/19 17:30'
        end
      end

      context 'タイトルに未入力値がある' do
        it 'タスクの新規登録が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'aaaaa'
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '登録済みのタイトルを入力する' do
        it 'タスクの新規登録が失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in 'task[title]', with: other_task.title
          fill_in 'Content', with: 'aaaaa'
          click_button 'Create Task'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task, user: user) }
    let(:other_task) { create(:task, user: user) }
    before { login_as(user) }
    before { visit edit_task_path(task) }

    context 'タスクの入力値が正常' do
      it 'タスクの編集が成功する' do
        fill_in 'task[title]', with: 'updating'
        select :done, from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content 'Title: updating'
        expect(page).to have_content 'Status: done'
        expect(page).to have_content 'Task was successfully updated.'
      end
    end

    context 'タイトルが未入力' do
      it 'タスクの編集が失敗する' do
        fill_in 'task[title]', with: nil
        select :todo, from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content "Title can't be blank"
      end
    end

    context '登録済みのタイトルを登録する' do
      it 'タスクの編集に失敗する' do
        fill_in 'task[title]', with: other_task.title
        select 'todo', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content 'Title has already been taken'
        expect(current_path).to eq task_path(task)
      end
    end
  end

  describe 'タスク削除' do
    before { login_as(user) }
    let!(:task) { create(:task, user: user) }

    it 'タスクを削除する' do
      visit tasks_path
      click_link 'Destroy'
      expect(page.accept_confirm).to eq 'Are you sure?'
      expect(page).to have_content 'Task was successfully destroyed.'
      expect(current_path).to eq tasks_path
      expect(page).not_to have_content task.title
    end
  end

end
