# frozen_string_literal: true

# db/migrate/20261005040826_add_token_to_users.rb
# ユーザーテーブルにワンタイムトークンと有効期限を追加するマイグレーションファイル
class AddTokenToUsers < ActiveRecord::Migration[7.0]
# マイグレーションを実行するメソッド
  def change
# 【修正】ユーザーテーブルにトークン用のカラムを追加
    add_column :users, :token, :string

    # 【修正】ユーザーテーブルにトークンの有効期限用のカラムを追加
    add_column :users, :token_expires_at, :datetime

    # 【修正】トークンでの検索を高速化し一意性を保証するためインデックスを追加
    add_index :users, :token, unique: true
  end
end
