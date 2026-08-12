# frozen_string_literal: true

# 【追加】config/initializers/resend.rb
# Resend gemの初期設定ファイル
# 環境変数からAPIキーを読み込んでResendに設定する
Resend.api_key = ENV["RESEND_API_KEY"]