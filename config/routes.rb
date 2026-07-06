# frozen_string_literal: true

# config/routes.rb
# 「URL」と「処理（Controller）」をつなぐ仲介役
Rails.application.routes.draw do
  # Devise のルーティングを設定（カスタマイズしたコントローラを使用）
  devise_for :users, controllers: {
    # ログイン機能のコントローラーを指定
    sessions: 'users/sessions',
    # ユーザー登録・更新機能のコントローラーを指定
    registrations: 'users/registrations'
  }

  # Devise のパスをカスタマイズ（ヘッダーで使うパス名に合わせる）
  devise_scope :user do
    # ログインページのルート
    get 'login', to: 'users/sessions#new'
    # ログアウトのルート
    delete 'logout', to: 'users/sessions#destroy'
  end

  # ルート URL（ / ）にアクセスしたときに static_pages コントローラーの top アクションを実行
  root 'static_pages#top'

  # 飲水記録のルーティング
  resources :water_intakes, only: [:index] do
    # collection: 特定のリソースに依存しないアクションを定義
    collection do
      # 飲水記録の作成・削除を切り替えるルート
      post :toggle
    end
  end

  # ユーザー編集ページのルート（Devise の registrations で管理されるため不要）
  # resources :users, only: [:edit, :update]

  # 【追加】カレンダー画面（/calendar）のルーティング
  get 'calendar', to: 'calendars#index'

  # 【追加】お問い合わせページ
  get 'contact', to: 'static_pages#contact'
  # 【追加】利用規約ページ
  get 'terms', to: 'static_pages#terms'
  # 【追加】プライバシーポリシーページ
  get 'privacy', to: 'static_pages#privacy'
end
