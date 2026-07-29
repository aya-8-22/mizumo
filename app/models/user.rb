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
  validates :terms_of_service, acceptance: true, on: :create

  # 体重のバリデーション（任意入力）
  # 入力された場合のみ、数値であることと範囲をチェック
  validates :weight, numericality: {
                       # greater_than_or_equal_to: 20 で体重が20以上の値かをチェック
                       greater_than_or_equal_to: 20,
                       # less_than_or_equal_to: 222.2でデータベースの制約に合わせてを設定
                       # データベースの precision: 4, scale: 1 の制約により、999.9が最大値
                       less_than_or_equal_to: 200.0
                     },
                     # allow_nil: true で体重が未入力（nil）でもエラーにならない
                     # これにより、新規登録時は体重を入力しなくても登録できる
                     # 設定（体重）画面での必須チェックは、コントローラーで実行する
                     allow_nil: true

  # 目標水分摂取量のバリデーション（任意入力）
  # 入力された場合のみ、数値であることと範囲をチェック
  validates :target_water_intake, numericality: {
                                    # greater_than: 0 で目標水分摂取量が0より大きい値かをチェック
                                    greater_than: 0,
                                    # only_integer: true で整数のみを許可
                                    only_integer: true
                                  },
                                  # allow_nil: true で目標水分摂取量が未入力（nil）でもエラーにならない
                                  allow_nil: true

  # カスタムバリデーション:少なくとも1つの通知時間がオンになっているかチェック
  # validate メソッドでカスタムバリデーションを定義
  # at_least_one_notification_enabled メソッドを実行してバリデーションを行う
  validate :at_least_one_notification_enabled

  # ユーザーは複数の飲水記録を持つ
  has_many :water_intakes, dependent: :destroy

  # 【修正】初回設定完了フラグで判定（デフォルト値があっても初回かどうかを判定できる）
  def notification_times_set?
    # notification_times_confirmed が true なら設定済み
    notification_times_confirmed
  end

  private

  # 【修正】カスタムバリデーションメソッド:少なくとも1つの通知時間がオンになっているかチェック
  def at_least_one_notification_enabled
    # 8つの通知時間の有・無状態を配列にまとめる
    enabled_notifications = [
      wake_up_enabled,       # 起床時の有・無
      breakfast_enabled,     # 朝食時の有・無
      morning_enabled,       # 10時頃の有・無
      lunch_enabled,         # 昼食時の有・無
      afternoon_enabled,     # 15時頃の有・無
      bath_enabled,          # 入浴時の有・無
      dinner_enabled,        # 夕食時の有・無
      bedtime_enabled        # 就寝時の有・無
    ]

    # 【修正】配列の中に true が1つもない場合（すべて false の場合）
    # any? メソッドで配列の中に true が1つでもあるかをチェック
    # unless で「true が1つもない場合」にエラーを追加
    return if enabled_notifications.any?

    # エラーメッセージを追加
    # errors.add(:base, 'メッセージ') で全体に対するエラーを追加
    # :base を使うことで、特定のフィールドではなく全体のエラーとして表示される
    errors.add(:base, '少なくとも1つの通知時間を「通知有」にしてください')
  end
end
