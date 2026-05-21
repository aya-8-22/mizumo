# frozen_string_literal: true

# app/models/user.rb
# User クラスを定義（ApplicationRecord を継承）
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Devise の認証機能を有効化
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーは複数の飲水記録を持つ
  has_many :water_intakes, dependent: :destroy

  # 【修正】体重のバリデーション（新規登録時も更新時も必須）
  # presence: true で体重が空欄の場合にエラーを表示
  # numericality: { greater_than: 0, allow_blank: true } で体重が0より大きい値かをチェック
  # allow_blank: true で空欄の場合は numericality のバリデーションをスキップ
  validates :weight, presence: true, numericality: { greater_than: 0, allow_blank: true }
end
