# frozen_string_literal: true

# app/controllers/water_intakes_controller.rb
# 飲水記録に関する処理を行うコントローラー
class WaterIntakesController < ApplicationController
  # ログイン必須の設定
  before_action :authenticate_user!
  # 体重未設定の場合は設定画面にリダイレクト（indexアクションのみ）
  before_action :check_weight_setting, only: [:index]

  # 飲水記録の一覧表示
  def index
    # 今日の日付を取得
    @today = Date.today
    # 今日の飲水記録を取得（新しい順）
    @water_intakes = current_user.water_intakes.where('DATE(recorded_at) = ?', @today).order(recorded_at: :desc)
    # 今日の飲水量の合計を計算
    @today_total = @water_intakes.sum(:amount_ml)
    # 目標水分摂取量を取得
    @daily_goal = current_user.calculate_target_water_intake
  end

  # 飲水記録の作成
  def create
    # amount_ml パラメータを取得
    amount_ml = params[:amount_ml].to_i
    # recorded_at パラメータを取得（時刻のみ）
    time_str = params[:recorded_at]

    # 【修正】amount_ml が許可された値かチェック
    unless WaterIntake::ALLOWED_AMOUNTS.include?(amount_ml)
      # 許可されていない値の場合はエラーメッセージを設定
      flash.now[:alert] = '不正な水分量が送信されました'
      # エラーレスポンスを返す
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message') }
        format.html { redirect_to water_intakes_path, alert: '不正な水分量が送信されました' }
      end
      return
    end

    # 【修正】時刻が入力されているかチェック
    if time_str.blank?
      # 時刻が入力されていない場合はエラーメッセージを設定
      flash.now[:alert] = '時刻を入力してください'
      # エラーレスポンスを返す
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message') }
        format.html { redirect_to water_intakes_path, alert: '時刻を入力してください' }
      end
      return
    end

    # 今日の日付と時刻を組み合わせて recorded_at を作成
    recorded_at = Time.zone.parse("#{Date.today} #{time_str}")

    # 飲水記録を作成
    @water_intake = current_user.water_intakes.build(
      amount_ml: amount_ml,
      recorded_at: recorded_at
    )

    # 保存処理
    if @water_intake.save
      # 保存成功時の処理
      # 今日の日付を取得
      @today = Date.today
      # 今日の飲水記録を再取得
      @water_intakes = current_user.water_intakes.where('DATE(recorded_at) = ?', @today).order(recorded_at: :desc)
      # 今日の飲水量の合計を再計算
      @today_total = @water_intakes.sum(:amount_ml)
      # 目標水分摂取量を取得
      @daily_goal = current_user.calculate_target_water_intake
      # 進捗率を計算（0%〜100%）
      @progress_percentage = @daily_goal > 0 ? [(@today_total.to_f / @daily_goal * 100).round, 100].min : 0

      # 【修正】フラッシュメッセージを設定
      if @progress_percentage >= 100
        # 目標達成時のメッセージ（常時表示）
        flash.now[:achievement] = '🎉 目標を達成しました! 🎉'
      else
        # 通常の記録成功メッセージ（5秒で自動消去）
        flash.now[:notice] = '記録しました!'
      end

      # Turbo Stream 形式でレスポンスを返す
      respond_to do |format|
        # create.turbo_stream.erb を実行
        format.turbo_stream
        # HTMLフォーマットの場合はリダイレクト（念のため）
        format.html { redirect_to water_intakes_path, notice: '記録を追加しました' }
      end
    else
      # 保存失敗時の処理
      # 【修正】エラーメッセージを日本語化
      error_messages = @water_intake.errors.full_messages.join('、')
      # フラッシュメッセージを設定
      flash.now[:alert] = error_messages

      # Turbo Stream 形式でレスポンスを返す
      respond_to do |format|
        # エラーメッセージを返す
        format.turbo_stream { render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message') }
        # HTMLフォーマットの場合はリダイレクト（念のため）
        format.html { redirect_to water_intakes_path, alert: error_messages }
      end
    end
  end

  # 飲水記録の削除
  def destroy
    # 削除対象の記録を取得
    @water_intake = current_user.water_intakes.find(params[:id])
    # 記録を削除
    @water_intake.destroy

    # 今日の日付を取得
    @today = Date.today
    # 今日の飲水記録を再取得
    @water_intakes = current_user.water_intakes.where('DATE(recorded_at) = ?', @today).order(recorded_at: :desc)
    # 今日の飲水量の合計を再計算
    @today_total = @water_intakes.sum(:amount_ml)
    # 目標水分摂取量を取得
    @daily_goal = current_user.calculate_target_water_intake
    # 進捗率を計算（0%〜100%）
    @progress_percentage = @daily_goal > 0 ? [(@today_total.to_f / @daily_goal * 100).round, 100].min : 0

    # 【修正】フラッシュメッセージを設定（5秒で自動消去）
    flash.now[:notice] = '記録を削除しました'

    # Turbo Stream 形式でレスポンスを返す
    respond_to do |format|
      # destroy.turbo_stream.erb を実行
      format.turbo_stream
      # HTMLフォーマットの場合はリダイレクト（念のため）
      format.html { redirect_to water_intakes_path, notice: '記録を削除しました' }
    end
  end

  private

  # 体重が設定されているかチェックするメソッド
  def check_weight_setting
    # ユーザーの体重が未設定の場合は体重設定画面にリダイレクト
    if current_user.weight.blank?
      # 【修正】正しいパスにリダイレクト（edit_user_registration_pathを使用）
      redirect_to edit_user_registration_path, alert: '体重を設定してください'
    end
  end
end


