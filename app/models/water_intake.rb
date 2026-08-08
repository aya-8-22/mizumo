# frozen_string_literal: true

# app/models/water_intake.rb
# 飲水記録のモデル
class WaterIntake < ApplicationRecord
  # ユーザーとの関連付け（1人のユーザーは複数の飲水記録を持つ）
  belongs_to :user

  # 【修正】許可された水分量のリスト
  ALLOWED_AMOUNTS = [150, 200, 250].freeze

  # バリデーション: 記録日時が必須
  validates :recorded_at, presence: true

  # 【修正】バリデーション: 飲水量が必須であること
  validates :amount_ml, presence: true

  # 【修正】バリデーション: 飲水量が許可された値のみであること
  validates :amount_ml, inclusion: { in: ALLOWED_AMOUNTS, message: 'は150ml、200ml、250mlのいずれかを選択してください' }

  # 【修正】カスタムバリデーション: 未来の時刻は不可
  validate :recorded_at_cannot_be_in_the_future

  private

  # 【修正】未来の時刻をチェックするメソッド
  def recorded_at_cannot_be_in_the_future
    # recorded_at が存在し、かつ現在時刻より未来の場合
    return unless recorded_at.present? && recorded_at > Time.current

    # エラーメッセージを追加
    errors.add(:recorded_at, 'は未来の時刻を入力できません')
  end
end