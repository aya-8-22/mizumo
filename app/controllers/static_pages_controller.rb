# frozen_string_literal: true

# app/controllers/static_pages_controller.rb
# 静的ページ（トップページなど）を管理するコントローラー
class StaticPagesController < ApplicationController
  # トップページだけ認証をスキップ
  skip_before_action :authenticate_user!, only: [:top]

  # トップページを表示するアクション
  def top
    # 【修正】ログイン状態の場合、記録ページにリダイレクト
    return unless user_signed_in?

    redirect_to water_intakes_path
  end
end
