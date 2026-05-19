# frozen_string_literal: true

# app/controllers/water_intakes_controller.rb
# 飲水記録を管理するコントローラー
class WaterIntakesController < ApplicationController
  # ログイン必須のアクションに設定
  before_action :authenticate_user!

  # 記録一覧を表示するアクション
  def index
    # 過去7日間の日付を取得(今日を含む・逆順)
    @dates = (6.days.ago.to_date..Time.zone.today).to_a.reverse

    # 時間帯の設定(8:00、12:00、17:00)
    @time_slots = ['8:00', '12:00', '17:00']

    # 【修正】@datesの範囲に合わせて記録を取得し、日付と時間帯でインデックス化
    # 修正前: @dates.first.beginning_of_day..@dates.last.end_of_day
    # 修正後: @dates.last.beginning_of_day..@dates.first.end_of_day
    # 理由: @dates は逆順（新しい日付が先頭）なので、.last が最も古い日付、.first が最も新しい日付
    @intakes = current_user.water_intakes
                           .where(recorded_at: @dates.last.beginning_of_day..@dates.first.end_of_day)
                           .index_by { |intake| [intake.recorded_at.to_date, intake.time_slot] }
  end

  # 飲水記録を作成または削除するアクション
  def toggle
    # パラメータから日付と時間帯を取得
    date = params[:date].to_date
    # パラメータから時間帯を取得
    time_slot = params[:time_slot]

    # 記録を検索する処理を find_intake メソッドに分離
    intake = find_intake(date, time_slot)

    # 記録の削除・作成処理をそれぞれのメソッドに分離
    if intake
      # 記録が存在する場合は delete_intake メソッドを呼び出す
      delete_intake(intake)
    else
      # 記録が存在しない場合は create_intake メソッドを呼び出す
      create_intake(date, time_slot)
    end
  rescue StandardError => e
    # エラーが発生した場合の処理
    Rails.logger.error "Error in toggle action: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    # JSON形式でエラーレスポンスを返す
    render json: { status: 'error', message: e.message }, status: :unprocessable_entity
  end

  # private メソッドを追加
  private

  # 指定された日付と時間帯の記録を検索するメソッド
  def find_intake(date, time_slot)
    # その日の時間帯の記録を検索
    current_user.water_intakes
                .where(recorded_at: date.all_day)
                .find_by(time_slot: time_slot)
  end

  # 記録を削除してJSONレスポンスを返すメソッド
  def delete_intake(intake)
    # 記録を削除
    intake.destroy
    # JSON形式でレスポンスを返す
    render json: { status: 'deleted' }
  end

  # 記録を作成してJSONレスポンスを返すメソッド
  def create_intake(date, time_slot)
    # time_slot から時間を抽出して recorded_at を作成
    hour = time_slot.split(':')[0].to_i
    # 日付と時間を組み合わせて recorded_at を作成
    recorded_at = date.in_time_zone.change(hour: hour)

    # 記録を作成
    current_user.water_intakes.create!(
      recorded_at: recorded_at,
      time_slot: time_slot,
      amount_ml: 200 # MVP版では200ml固定
    )
    # JSON形式でレスポンスを返す
    render json: { status: 'created' }
  end
end
