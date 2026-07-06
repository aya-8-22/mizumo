# frozen_string_literal: true

# app/controllers/static_pages_controller.rb
# 静的ページ(トップページなど)を管理するコントローラー
class StaticPagesController < ApplicationController
  # トップページ、問い合わせ、利用規約、プライバシーは認証をスキップ
  skip_before_action :authenticate_user!, only: %i[top terms privacy contact]

  # トップページを表示するアクション
  def top
    # ログイン状態かどうかを確認
    return unless user_signed_in?

    # リファラー(参照元)を取得
    referer = request.referer

    # 【修正】リファラーが存在し、かつ自サイトからのアクセスの場合は何もしない
    return if referer.present? && referer.start_with?(request.base_url)

    # 【修正】それ以外の場合は記録ページにリダイレクト
    redirect_to water_intakes_path
  end

  # 【修正】利用規約ページ
  def terms
    # 利用規約ページを表示
  end

  # 【修正】プライバシーポリシーページ
  def privacy
    # プライバシーポリシーページを表示
  end

  # 【修正】問い合わせページ
  def contact
    # 問い合わせページを表示
  end
end
