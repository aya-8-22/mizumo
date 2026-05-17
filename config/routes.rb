# frozen_string_literal: true

# config/routes.rb
# Rails アプリケーションのルーティング（URL とコントローラーの紐付け）を設定するファイル
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

  # 【削除】ユーザー編集ページのルート（Devise の registrations で管理されるため不要）
  # resources :users, only: [:edit, :update]
end
