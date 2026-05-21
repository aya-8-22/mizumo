# frozen_string_literal: true

# app/controllers/static_pages_controller.rb
# 静的ページ(トップページなど)を管理するコントローラー
class StaticPagesController < ApplicationController
  # トップページだけ認証をスキップ
  skip_before_action :authenticate_user!, only: [:top]

  # トップページを表示するアクション
  def top
    # ログイン状態かどうかを確認
    return unless user_signed_in?

    # 【修正】リファラー(参照元)を取得
    referer = request.referer

    # 【修正】リファラーが存在しない、または外部サイトからのアクセスの場合
    # (ブラウザを閉じて直接アクセスした場合など)
    return unless referer.blank? || !referer.start_with?(request.base_url)

    # 記録ページにリダイレクト
    redirect_to water_intakes_path

    # 【修正】リファラーが存在する場合(ヘッダーのトップページボタンから来た場合など)
    # トップページを表示(何もしない)
  end
end
