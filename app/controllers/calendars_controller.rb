# frozen_string_literal: true

# 【追加】app/controllers/calendars_controller.rb
# カレンダー画面を表示するコントローラー
class CalendarsController < ApplicationController
  # Devise の認証機能を使用（ログインしていないユーザーはアクセス不可）
  before_action :authenticate_user!

  # カレンダー画面のトップページ
  def index
    # 現在は仮実装のため、特に処理は行わない
    # 今後、カレンダー機能を実装する際にここに処理を追加する
  end
end
