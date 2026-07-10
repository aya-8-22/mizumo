# frozen_string_literal: true

# ↑ 文字列を変更不可にしてメモリ使用量を削減する設定（Ruby の最適化）

# app/helpers/application_helper.rb
# ヘルパーファイル
# メッセージタイプを Bootstrap のクラス名に変換する処理 ロジック（判断・計算）を担当 再利用可能な処理を定義

# ApplicationHelper モジュールを定義
# アプリケーション全体で使えるヘルパーメソッドをまとめる場所
module ApplicationHelper
  # Flash メッセージのタイプを Bootstrap のクラス名に変換するメソッド
  # 引数: flash_type（例: 'notice', 'alert' など）
  # 戻り値: Bootstrap のクラス名（例: 'success', 'danger' など）
  def bootstrap_class_for(flash_type)
    # flash_type を文字列に変換して、条件分岐で判定
    case flash_type.to_s
    when 'notice'
      'success'  # 緑色（成功メッセージ）を返す
    when 'alert', 'error'
      'danger'   # 赤色（エラーメッセージ）を返す
    when 'warning'
      'warning'  # 黄色（警告メッセージ）を返す
    when 'info'
      'info'     # 青色（情報メッセージ）を返す
    else
      # 上記以外の場合は、そのまま flash_type を文字列として返す
      flash_type.to_s
    end
  end

  # ページタイトルを動的に設定するメソッド
  # 引数: page_title(ページごとのタイトル、デフォルトは nil)
  # 戻り値: ページタイトル（例: 'ログイン | ミズモ' または 'ミズモ'）
  def page_title(page_title = nil)
    base_title = 'ミズモ' # アプリケーション名
    # page_title が存在する場合は「ページタイトル | ミズモ」、存在しない場合は「ミズモ」のみを返す
    page_title.present? ? "#{page_title} | #{base_title}" : base_title
  end

  # 【追加】ボトムナビゲーションを表示するかどうかを判定するメソッド
  # 戻り値: true(表示する) / false(表示しない)
  def show_bottom_navigation?
    # 【修正】新規登録完了画面では常に非表示にする
    return false if controller_name == 'registrations' && action_name == 'complete'

    # ログイン中の場合は常に表示
    return true if user_signed_in?

    # 【修正】ログイン前の場合、特定のページでのみ表示
    # - ホーム画面(トップページ): static_pages#top
    # - お問い合わせ画面: static_pages#contact
    # - 利用規約画面: static_pages#terms
    # - プライバシーポリシー画面: static_pages#privacy
    controller_name == 'static_pages' && %w[top contact terms privacy].include?(action_name)
  end
end
