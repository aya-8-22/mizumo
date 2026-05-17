# frozen_string_literal: true

# app/models/water_intake.rb
# 飲水記録のモデル
class WaterIntake < ApplicationRecord
  # ユーザーとの関連付け（1人のユーザーは複数の飲水記録を持つ）
  belongs_to :user

  # 【修正】バリデーション: 記録日時が必須
  validates :recorded_at, presence: true

  # 【修正】バリデーション: 時間帯が必須
  validates :time_slot, presence: true

  # 【修正】バリデーション: 飲水量が必須
  validates :amount_ml, presence: true

  # 【修正】バリデーション: 飲水量が0より大きい
  validates :amount_ml, numericality: { greater_than: 0 }
end
