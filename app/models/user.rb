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

  # 利用規約の同意チェック（新規登録時のみ必須）
  # acceptance: true で利用規約にチェックが入っていない場合にエラーを表示
  # on: :create で新規登録時のみバリデーションを実行
  # message: オプションを削除して、config/locales/activerecord/ja.yml の設定を優先
  validates :terms_of_service, acceptance: true, on: :create

  # 体重のバリデーション（任意入力）
  # 入力された場合のみ、数値であることと範囲をチェック
  validates :weight, numericality: {
                       # greater_than_or_equal_to: 20 で体重が20以上の値かをチェック
                       greater_than_or_equal_to: 20,
                       # less_than_or_equal_to: 200 で体重が200以下の値かをチェック
                       less_than_or_equal_to: 200,
                       # only_integer: true で整数のみを許可
                       only_integer: true
                     },
                     # allow_nil: true で体重が未入力（nil）でもエラーにならない
                     # これにより、新規登録時は体重を入力しなくても登録できる
                     # 設定（体重）画面での必須チェックは、コントローラーで実行する
                     allow_nil: true,
                     # unless: :skip_weight_validation で skip_weight_validation が true の場合はバリデーションをスキップ
                     unless: :skip_weight_validation

  # 同一時刻のバリデーション（通知時間設定画面でも実行する）
  validate :no_duplicate_notification_times

  # ユーザーは複数の飲水記録を持つ
  has_many :water_intakes, dependent: :destroy

  # 体重のバリデーションをスキップするかどうかを判定する属性
  # attr_accessor で仮想属性を定義（DBには保存されない）
  attr_accessor :skip_weight_validation

  # 初回設定完了フラグで判定（デフォルト値があっても初回かどうかを判定できる）
  def notification_times_set?
    # notification_times_confirmed が true なら設定済み
    notification_times_confirmed
  end

  # 目標水分摂取量を計算するメソッド メソッド名を変更（カラム名と衝突しないように）
  def calculate_target_water_intake
    # 体重が設定されている場合のみ計算
    # weight が nil または 0 の場合は 0 を返す
    return 0 if weight.blank? || weight.zero?

    # 体重 × 30ml で計算
    # to_i で整数に変換
    (weight * 30).to_i
  end

  private

  def no_duplicate_notification_times
    # 通知が有効な時間帯のみを取得
    enabled_times = []
  
    # 8つの時間帯について、通知が有効な場合のみ時刻を配列に追加
    enabled_times << wake_up_time if ActiveModel::Type::Boolean.new.cast(wake_up_enabled) && wake_up_time.present?
    enabled_times << breakfast_time if ActiveModel::Type::Boolean.new.cast(breakfast_enabled) && breakfast_time.present?
    enabled_times << morning_time if ActiveModel::Type::Boolean.new.cast(morning_enabled) && morning_time.present?
    enabled_times << lunch_time if ActiveModel::Type::Boolean.new.cast(lunch_enabled) && lunch_time.present?
    enabled_times << afternoon_time if ActiveModel::Type::Boolean.new.cast(afternoon_enabled) && afternoon_time.present?
    enabled_times << bath_time if ActiveModel::Type::Boolean.new.cast(bath_enabled) && bath_time.present?
    enabled_times << dinner_time if ActiveModel::Type::Boolean.new.cast(dinner_enabled) && dinner_time.present?
    enabled_times << bedtime if ActiveModel::Type::Boolean.new.cast(bedtime_enabled) && bedtime.present?

    # 時刻が1つも設定されていない場合はバリデーションをスキップ
    return if enabled_times.empty?

    # 時刻を「時:分」の文字列に変換する
    time_strings = enabled_times.map { |t| t.strftime('%H:%M') }

    # 重複があるかチェックする（配列のサイズと重複を除いた配列のサイズを比較）
    if time_strings.size != time_strings.uniq.size
      # 重複が検出された場合、エラーメッセージを追加
      errors.add(:base, :duplicate_notification_times)
    end
  end
end