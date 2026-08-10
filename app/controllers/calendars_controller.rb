# frozen_string_literal: true

# 【修正】app/controllers/calendars_controller.rb
# カレンダー画面を表示するコントローラー
class CalendarsController < ApplicationController
  # ログインしていないユーザーはアクセス不可
  before_action :authenticate_user!

  # カレンダー画面のトップページ
  def index
    # 表示する月を取得（パラメータがなければ今月）
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today

    # カレンダーに表示する月の飲水記録を取得
    # beginning_of_month: 月の最初の日（例: 2025-01-01）
    # end_of_month: 月の最後の日（例: 2025-01-31）
    @water_intakes = current_user.water_intakes
                                  .where(recorded_at: @start_date.beginning_of_month..@start_date.end_of_month)
                                  .order(:recorded_at)

    # 日付ごとの達成状況を整理（ハッシュで管理）
    @goal_achievements = {}

    # カレンダーに表示する月の各日付について達成状況を取得
    (@start_date.beginning_of_month..@start_date.end_of_month).each do |date|
      # 日付をキーにして、達成状況を格納
      # true: 達成、false: 未達成
      @goal_achievements[date] = WaterIntake.goal_achieved_for_date?(current_user, date)
    end
  end
end
