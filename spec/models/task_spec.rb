require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'バリデーション' do

    it 'バリデーションに引っかからない' do
      task = build(:task)
      expect(task).to be_valid
    end

    it 'タイトルがない' do 
      task_without_title = build(:task, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end
  
    it 'ステータスを決めていない' do
      task_without_status = build(:task, status: nil)
      expect(task_without_status).to be_invalid
      expect(task_without_status.errors[:status]).to eq ["can't be blank"]
    end

    it 'タイトルが重複している' do
      task = create(:task)
      task_duplicate_title = build(:task, title: task.title)
      expect(task_duplicate_title).to be_invalid
      expect(task_duplicate_title.errors[:title]).to eq ["already title"]
    end

    it '別タイトルのタスクを作成する' do
      task = create(:task)
      task_another_title = build(:task, title: 'another title')
      expect(task_another_title).to be_valid
    end
  end

end
