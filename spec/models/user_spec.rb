# frozen_string_literal: true

# 【追加】spec/models/user_spec.rb
# Userモデル（ユーザーに関するデータ処理や機能）が正しく動作するかを検証するテストファイル

# Railsのテスト環境とRSpecの設定を読み込む
require 'rails_helper'

# Userモデルの単体テスト（モデルスペック）を開始
RSpec.describe User, type: :model do
  # テスト用のユーザーデータを事前に作成し、変数 user に格納
  let(:user) { User.create!(email: 'test@example.com', password: 'password123', terms_of_service: true) }

  # generate_one_time_token! メソッドのテストグループ
  describe '#generate_one_time_token!' do
    # トークンが正しく生成されることのテスト
    it 'トークンが生成され、有効期限が24時間後に設定されること' do
      # トークン生成メソッドを実行
      user.generate_one_time_token!

      # トークンが存在することを確認
      expect(user.token).not_to be_nil
      # 有効期限が現在時刻より未来（およそ24時間後）に設定されていることを確認
      expect(user.token_expires_at).to be > Time.current
    end
  end

  # #token_expired? メソッドのテストグループ
  describe '#token_expired?' do
    # 有効期限内（未来）の場合のテスト
    it '有効期限内の場合はfalseを返すこと' do
      # 有効期限を未来の時間に設定
      user.update!(token_expires_at: 1.hour.from_now)

      # 期限切れではない（false）ことを確認
      expect(user.token_expired?).to be false
    end

    # 有効期限切れ（過去）の場合のテスト
    it '有効期限が切れている場合はtrueを返すこと' do
      # 有効期限を1時間前の過去に設定
      user.update!(token_expires_at: 1.hour.ago)

      # 期限切れである（true）ことを確認
      expect(user.token_expired?).to be true
    end
  end
end
