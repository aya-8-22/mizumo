# frozen_string_literal: true
# db/migrate/20260506060851_devise_create_users.rb
# データベースに users テーブルを作成するためのマイグレーションファイル

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    # users テーブルを作成
    create_table :users do |t|
      ## Database authenticatable（メールアドレスとパスワードでログイン）
      t.string :email,              null: false, default: "" # メールアドレス（必須、空文字がデフォルト）
      t.string :encrypted_password, null: false, default: "" # 暗号化されたパスワード（必須、空文字がデフォルト）

      ## Recoverable（パスワードリセット機能）
      t.string   :reset_password_token # パスワードリセット用のトークン
      t.datetime :reset_password_sent_at # パスワードリセットメールの送信日時

      ## Rememberable（ログイン状態の保持）
      t.datetime :remember_created_at # ログイン状態を保持した日時

      ## 【追加】weight（カラム体重を保存）
      t.decimal :weight, precision: 5, scale: 2 # 体重（整数部3桁、小数部2桁、例：999.99kg）

      ## Trackable（ログイン履歴の追跡）※コメントアウト（使用しない）
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable（メール確認機能）※コメントアウト（使用しない）
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable（アカウントロック機能）※コメントアウト（使用しない）
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps null: false # created_at（作成日時）と updated_at（更新日時）を自動追加
    end

    # メールアドレスにユニークインデックスを追加（重複を防ぐ）
    add_index :users, :email,                unique: true
    # パスワードリセットトークンにユニークインデックスを追加（重複を防ぐ）
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end