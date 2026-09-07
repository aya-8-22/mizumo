# frozen_string_literal: true

# ↑ 文字列を変更不可にしてメモリ使用量を削減する設定(Ruby の最適化)

# app/helpers/application_helper.rb
# ヘルパーファイル
# メッセージタイプを Bootstrap のクラス名に変換する処理 ロジック(判断・計算)を担当 再利用可能な処理を定義

# ApplicationHelper モジュールを定義
# アプリケーション全体で使えるヘルパーメソッドをまとめる場所
module ApplicationHelper
  # Flash メッセージのタイプを Bootstrap のクラス名に変換するメソッド
  # 引数: flash_type(例: 'notice', 'alert' など)
  # 戻り値: Bootstrap のクラス名(例: 'success', 'danger' など)
  def bootstrap_class_for(flash_type)
    # flash_type を文字列に変換して、条件分岐で判定
    case flash_type.to_s
    when 'notice'
      'success'  # 緑色(成功メッセージ)を返す
    when 'alert', 'error'
      'danger'   # 赤色(エラーメッセージ)を返す
    when 'warning'
      'warning'  # 黄色(警告メッセージ)を返す
    when 'info'
      'info'     # 青色(情報メッセージ)を返す
    else
      # 上記以外の場合は、そのまま flash_type を文字列として返す
      flash_type.to_s
    end
  end

  # ページタイトルを動的に設定するメソッド
  # 引数: page_title(ページごとのタイトル、デフォルトは nil)
  # 戻り値: ページタイトル(例: 'ログイン | ミズモ' または 'ミズモ')
  def page_title(page_title = nil)
    base_title = 'ミズモ' # アプリケーション名
    # page_title が存在する場合は「ページタイトル | ミズモ」、存在しない場合は「ミズモ」のみを返す
    page_title.present? ? "#{page_title} | #{base_title}" : base_title
  end

  # ヘッダーを表示するかどうかを判定するメソッド
  def show_header?(first_time: false)
    # 【修正】ヘッダーを非表示にする画面かどうかを判定
    return false if hide_header_page?

    # 通知時間設定画面の場合は first_time で判定
    return !first_time if notification_time_settings_page?

    # 体重設定画面で体重が未設定の場合は非表示
    return current_user&.weight.present? if weight_settings_edit_page?

    # その他の画面では常にヘッダーを表示
    true
  end

  # ボトムナビゲーションを表示するかどうかを判定するメソッド
  def show_bottom_navigation?(first_time: false)
    # 非表示にする画面を判定
    return false if hide_bottom_navigation_page?

    # 通知時間設定画面の場合は first_time で判定
    return !first_time if notification_time_settings_page?

    # 体重設定画面で体重が未設定の場合は非表示
    return current_user&.weight.present? if weight_settings_edit_page?

    # ログイン中の場合は常に表示
    return true if user_signed_in?

    # ログイン前の場合、特定のページでのみ表示
    static_pages_with_bottom_navigation?
  end

  private

  # 通知時間設定画面かどうかを判定
  def notification_time_settings_page?
    # controller_path が 'notification_time_settings' かつ action_name が 'edit' または 'update' の場合に true を返す
    controller_path == 'notification_time_settings' && %w[edit update].include?(action_name)
  end

  # 体重設定画面(edit)かどうかを判定
  def weight_settings_edit_page?
    # controller_path が 'weight_settings' かつ action_name が 'edit' の場合に true を返す
    controller_path == 'weight_settings' && action_name == 'edit'
  end

  # 【修正】ヘッダーを非表示にする画面かどうかを判定
  def hide_header_page?
    # 新規登録完了画面かどうかを判定
    return true if controller_path == 'users/registrations' && action_name == 'complete'

    # パスワード変更完了画面かどうかを判定
    return true if password_change_complete_page?

    # 上記以外の場合は false を返す
    false
  end

  # ボトムナビゲーションを非表示にする画面かどうかを判定
  def hide_bottom_navigation_page?
    # 新規登録関連の画面かどうかを判定
    return true if registration_page?

    # ログイン画面かどうかを判定
    return true if login_page?

    # 【修正】パスワード変更画面かどうかを判定
    # return true if password_settings_page?

    # 【修正】パスワード変更完了画面かどうかを判定
    return true if password_change_complete_page?

    # 上記以外の場合は false を返す
    false
  end

  # 新規登録関連の画面かどうかを判定
  def registration_page?
    # controller_path が 'users/registrations' の場合に true を返す
    # action_name が 'complete' または 'new' の場合に true を返す
    controller_path == 'users/registrations' && %w[complete new].include?(action_name)
  end

  # ログイン画面かどうかを判定
  def login_page?
    # controller_path が 'users/sessions' かつ action_name が 'new' の場合に true を返す
    controller_path == 'users/sessions' && action_name == 'new'
  end

  # 【修正】パスワード変更画面かどうかを判定
  def password_settings_page?
    # controller_path が 'password_settings' かつ action_name が 'edit' の場合に true を返す
    controller_path == 'password_settings' && action_name == 'edit'
  end

  # 【修正】パスワード変更完了画面かどうかを判定
  def password_change_complete_page?
    # controller_path が 'password_settings' かつ action_name が 'complete' の場合に true を返す
    controller_path == 'password_settings' && action_name == 'complete'
  end

  # ログイン前でボトムナビゲーションを表示する画面かどうかを判定
  def static_pages_with_bottom_navigation?
    # controller_path が 'static_pages' の場合に true を返す
    # action_name が 'top', 'contact', 'terms', 'privacy' のいずれかの場合に true を返す
    controller_path == 'static_pages' && %w[top contact terms privacy].include?(action_name)
  end
end
