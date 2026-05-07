# frozen_string_literal: true
# 文字列を変更不可にしてメモリ効率を改善するRubyの機能

# app/controllers/application_controller.rb
# 【追加】このファイルのパスを示すコメント（全コントローラーの基底クラス）

# ApplicationController クラスの定義（全コントローラーの親クラス）
class ApplicationController < ActionController::Base
  # Deviseのコントローラーが呼ばれる前に configure_permitted_parameters メソッドを実行
  # if: :devise_controller? で Devise のコントローラーの場合のみ実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  # protected メソッド（このクラスと継承先のクラスからのみ呼び出せる）
  protected

  # Devise のストロングパラメーターを設定するメソッド
  # セキュリティのため、許可されたパラメーターのみを受け取る
  def configure_permitted_parameters
    # サインアップ時に weight パラメーターを許可
    # permit(:sign_up, keys: [:weight]) で weight を受け取れるようにする
    devise_parameter_sanitizer.permit(:sign_up, keys: [:weight])
    
    # 【追加】アカウント更新時に weight パラメーターを許可
    # permit(:account_update, keys: [:weight]) で weight を更新できるようにする
    devise_parameter_sanitizer.permit(:account_update, keys: [:weight])
  end
end