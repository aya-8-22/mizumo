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

    # @datesの範囲に合わせて記録を取得し、日付と時間帯でインデックス化
    @intakes = current_user.water_intakes
                           .where(recorded_at: @dates.first.beginning_of_day..@dates.last.end_of_day)
                           .index_by { |intake| [intake.recorded_at.to_date, intake.time_slot] }
  end

  # 飲水記録を作成または削除するアクション
  # メソッドを分割して、複雑さを下げた
  def toggle
    # パラメータから日付と時間帯を取得
    date = params[:date].to_date
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
  end

  # private メソッドを追加
  private

  # 指定された日付と時間帯の記録を検索するメソッド
  # 元の toggle メソッドから検索処理を分離
  def find_intake(date, time_slot)
    # その日の時間帯の記録を検索
    current_user.water_intakes
                .where(recorded_at: date.all_day)
                .find_by(time_slot: time_slot)
  end

  # 記録を削除してJSONレスポンスを返すメソッド
  # 元の toggle メソッドから削除処理を分離
  def delete_intake(intake)
    # 記録を削除
    intake.destroy
    # JSON形式でレスポンスを返す
    render json: { status: 'deleted' }
  end

  # 記録を作成してJSONレスポンスを返すメソッド
  # 元の toggle メソッドから作成処理を分離
  # MVP版では200ml固定だが、データベースの制約のため amount_ml に200を保存
  def create_intake(date, time_slot)
    # 記録を作成
    current_user.water_intakes.create!(
      recorded_at: date.in_time_zone.change(hour: time_slot.split(':')[0].to_i),
      time_slot: time_slot,
      amount_ml: 200 # データベースの制約のため、200を保存
    )
    # JSON形式でレスポンスを返す
    render json: { status: 'created' }
  end
end
