# frozen_string_literal: true

# 【追加】app/controllers/static_pages_controller.rb
# 静的ページ（トップページなど）を管理するコントローラー
class StaticPagesController < ApplicationController
  # 【追加】トップページだけ認証をスキップ
  skip_before_action :authenticate_user!, only: [:top]
  # トップページを表示するアクション
  def top; end
end
