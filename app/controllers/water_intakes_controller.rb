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
    # 【修正】今日の飲水記録を集計してインスタンス変数にセットする
    set_daily_water_summary
  end

  # 飲水記録の作成
  def create
    # amount_ml パラメータを取得
    amount_ml = params[:amount_ml].to_i
    # recorded_at パラメータを取得（時刻のみ）
    time_str = params[:recorded_at]

    # 【修正】amount_ml が許可された値でなければエラー表示して処理を終了する
    return render_flash_error(t('controllers.water_intakes.invalid_amount')) unless valid_amount?(amount_ml)
    # 【修正】時刻が入力されていなければエラー表示して処理を終了する
    return render_flash_error(t('controllers.water_intakes.missing_time')) if time_str.blank?

    # 【修正】飲水記録のインスタンスを組み立てる(まだ保存しない)
    @water_intake = build_water_intake(amount_ml, time_str)

    # 保存を試みて、成功したかどうかで処理を分岐する
    if @water_intake.save
      # 【修正】保存成功時の後処理(集計・フラッシュ・レスポンス)をまとめて実行する
      handle_successful_create
    else
      # 【修正】保存失敗: バリデーションエラーをまとめてエラー表示する
      render_flash_error(@water_intake.errors.full_messages.join('、'))
    end
  end

  # 飲水記録の削除
  def destroy
    # 削除対象の記録を取得
    @water_intake = current_user.water_intakes.find(params[:id])
    # 記録を削除
    @water_intake.destroy

    # 【修正】削除後の今日の飲水記録を再集計する
    set_daily_water_summary
    # フラッシュメッセージを設定（5秒で自動消去）'記録を削除しました'
    flash.now[:notice] = t('controllers.water_intakes.deleted')

    # Turbo Stream 形式でレスポンスを返す
    respond_to do |format|
      # destroy.turbo_stream.erb を実行
      format.turbo_stream
      # HTMLフォーマットの場合はリダイレクト（念のため）'記録を削除しました'
      format.html { redirect_to water_intakes_path, notice: t('controllers.water_intakes.deleted') }
    end
  end

  private

  # 【修正】amount_ml が許可された値かどうかを判定する
  def valid_amount?(amount_ml)
    # ALLOWED_AMOUNTS定数に含まれているかチェックする
    WaterIntake::ALLOWED_AMOUNTS.include?(amount_ml)
  end

  # 【修正】飲水記録のインスタンスを組み立てる(まだ保存しない)
  def build_water_intake(amount_ml, time_str)
    # 今日の日付と時刻を組み合わせて recorded_at を作成する
    recorded_at = Time.zone.parse("#{Time.zone.today} #{time_str}")
    # current_userに紐づく飲水記録インスタンスを作成する(保存はまだしない)
    current_user.water_intakes.build(amount_ml: amount_ml, recorded_at: recorded_at)
  end

  # 【修正】保存成功時の後処理(集計・フラッシュ・レスポンス)をまとめる
  def handle_successful_create
    # 今日の飲水記録を再集計する
    set_daily_water_summary
    # 進捗に応じたフラッシュメッセージをセットする
    set_success_flash

    # Turbo Stream 形式でレスポンスを返す
    respond_to do |format|
      # create.turbo_stream.erb を実行する
      format.turbo_stream
      # HTMLフォーマットの場合はリダイレクトする(念のため)'記録を追加しました'
      format.html { redirect_to water_intakes_path, notice: t('controllers.water_intakes.created') }
    end
  end

  # 【修正】保存成功時のフラッシュメッセージを進捗に応じて切り替える
  def set_success_flash
    # 進捗率が100%以上なら目標達成メッセージを表示する
    if @progress_percentage >= 100
      flash.now[:achievement] = t('controllers.water_intakes.achievement')
    else
      # それ以外は通常の記録成功メッセージを表示する
      flash.now[:notice] = t('controllers.water_intakes.recorded')
    end
  end

  # 【修正】今日の飲水記録を集計してインスタンス変数にセットする
  def set_daily_water_summary
    # 今日の日付を取得
    @today = Time.zone.today
    # 今日の飲水記録を再取得
    @water_intakes = current_user.water_intakes.where('DATE(recorded_at) = ?', @today).order(recorded_at: :desc)
    # 今日の飲水量の合計を再計算
    @today_total = @water_intakes.sum(:amount_ml)
    # 目標水分摂取量を取得
    @daily_goal = current_user.calculate_target_water_intake
    # 進捗率を計算（0%〜100%）
    @progress_percentage = @daily_goal.positive? ? [(@today_total.to_f / @daily_goal * 100).round, 100].min : 0
  end

  # 【修正】エラー時のフラッシュメッセージとレスポンスをまとめて処理する
  def render_flash_error(message)
    # フラッシュメッセージを設定
    flash.now[:alert] = message
    # Turbo Stream 形式でレスポンスを返す
    respond_to do |format|
      # エラーメッセージを返す
      format.turbo_stream { render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message') }
      # HTMLフォーマットの場合はリダイレクト（念のため）
      format.html { redirect_to water_intakes_path, alert: message }
    end
  end

  # 体重が設定されているかチェックするメソッド
  def check_weight_setting
    # ユーザーの体重が未設定の場合は体重設定画面にリダイレクト
    return if current_user.weight.present?

    # 正しいパスにリダイレクト（edit_user_registration_pathを使用）'体重を設定してください'
    redirect_to edit_user_registration_path, alert: t('controllers.water_intakes.missing_weight')
  end
end
