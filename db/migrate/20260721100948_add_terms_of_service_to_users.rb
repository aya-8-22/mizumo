# frozen_string_literal: true

# db/migrate/20260721100948_add_terms_of_service_to_users.rb
# Users テーブルに terms_of_service カラムを追加するマイグレーションファイル
class AddTermsOfServiceToUsers < ActiveRecord::Migration[7.0]
  # マイグレーション実行時に呼ばれるメソッド
  def change
    # users テーブルに terms_of_service カラムを追加
    # データ型: boolean（true または false）
    # デフォルト値: false（利用規約に同意していない状態）
    # NOT NULL 制約: あり（必ず値が入る）
    add_column :users, :terms_of_service, :boolean, default: false, null: false
  end
end
