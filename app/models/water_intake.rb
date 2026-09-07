# frozen_string_literal: true

# app/models/water_intake.rb
# 飲水記録のモデル
class WaterIntake < ApplicationRecord
  # ユーザーとの関連付け（1人のユーザーは複数の飲水記録を持つ）
  belongs_to :user

  # 許可された水分量のリスト
  ALLOWED_AMOUNTS = [150, 200, 250].freeze

  # バリデーション: 記録日時が必須
  validates :recorded_at, presence: true

  # バリデーション: 飲水量が必須であること
  validates :amount_ml, presence: true

  # バリデーション: 飲水量が許可された値のみであること
  validates :amount_ml, inclusion: { in: ALLOWED_AMOUNTS, message: 'は150ml、200ml、250mlのいずれかを選択してください' }

  # カスタムバリデーション: 未来の時刻は不可
  validate :recorded_at_cannot_be_in_the_future

  # 【追加】指定した日付の合計飲水量を取得する
  # @param user [User] ユーザー
  # @param date [Date] 日付
  # @return [Integer] 合計飲水量（ml）
  def self.total_amount_for_date(user, date)
    # 指定したユーザーの、指定した日付（00:00:00〜23:59:59）の飲水記録を取得
    where(user: user, recorded_at: date.all_day)
      # 飲水量の合計を計算
      .sum(:amount_ml)
  end

  # 【追加】指定した日付の目標達成判定
  # @param user [User] ユーザー
  # @param date [Date] 日付
  # @return [Boolean] 目標達成したか（true: 達成、false: 未達成）
  def self.goal_achieved_for_date?(user, date)
    # 指定した日付の合計飲水量を取得
    total = total_amount_for_date(user, date)

    # ユーザーの目標水分摂取量を取得（体重 × 30ml）
    target = user.calculate_target_water_intake

    # 合計飲水量が目標以上なら達成（true）、未達成なら false
    total >= target
  end

  private

  # 未来の時刻をチェックするメソッド
  def recorded_at_cannot_be_in_the_future
    # recorded_at が存在し、かつ現在時刻より未来の場合
    return unless recorded_at.present? && recorded_at > Time.current

    # エラーメッセージを追加
    errors.add(:recorded_at, 'は未来の時刻を入力できません')
  end
end