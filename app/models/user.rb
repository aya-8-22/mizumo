# frozen_string_literal: true

# app/models/user.rb
# 「ユーザー（会員）に関するデータの内容や、データを取り扱う際の決まりごとを定義している設計図」
# User クラスを定義（ApplicationRecord を継承）
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Devise の認証機能を有効化
  # :database_authenticatable → メールアドレスとパスワードでログイン
  # :registerable → ユーザー登録機能を有効化
  # :recoverable → パスワードリセット機能を有効化
  # :rememberable → 「ログイン状態を保持する」機能を有効化
  # :validatable → メールアドレスとパスワードのバリデーションを自動で追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーは複数の飲水記録を持つ
  has_many :water_intakes, dependent: :destroy

  # 【修正】利用規約の同意用の仮想属性を追加（DBには保存しない）
  attr_accessor :terms_of_service

  # 【修正】体重のバリデーション（体重設定画面での更新時のみ必須）
  # on: :update_weight で、体重設定画面での更新時のみバリデーションを実行
  validates :weight, presence: true, numericality: { greater_than: 0 }, on: :update_weight

  # 【修正】体重が設定されている場合のみ、0より大きい値かをチェック
  # allow_nil: true で体重が nil の場合はバリデーションをスキップ
  validates :weight, numericality: { greater_than: 0, allow_nil: true }

  # 【修正】利用規約の同意チェック（新規登録時のみ必須）
  # acceptance: true で利用規約にチェックが入っていない場合にエラーを表示
  # on: :create で新規登録時のみバリデーションを実行
  validates :terms_of_service, acceptance: true, on: :create
end
