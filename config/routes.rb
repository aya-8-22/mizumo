# frozen_string_literal: true

# config/routes.rb
# 「URL」と「処理（Controller）」をつなぐ仲介役
Rails.application.routes.draw do
  # get 'password_settings/edit'
  # get 'password_settings/update'
  get 'notification_time_settings/edit'
  get 'notification_time_settings/update'
  get 'weight_settings/edit'
  get 'weight_settings/update'
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
    # 登録完了画面のルートを devise_scope の中に移動
    get 'users/registration/complete', to: 'users/registrations#complete', as: :users_registration_complete
  end

  # 設定画面のルートを追加
  # namespace :users do
  # 体重設定画面の表示ルート
  # get 'settings/weight', to: 'settings#edit_weight', as: :edit_weight
  # 体重更新のルート
  # patch 'settings/weight', to: 'settings#update_weight', as: :update_weight

  # 通知時間設定画面の表示ルート
  # get 'settings/notification', to: 'settings#edit_notification', as: :edit_notification
  # 通知時間更新のルート
  # patch 'settings/notification', to: 'settings#update_notification', as: :update_notification
  # end

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

  # カレンダー画面（/calendar）のルーティング
  get 'calendar', to: 'calendars#index'

  # 【追加】体重設定画面のルーティング（単数リソース）
  # resource を使うことで、編集edit と 更新update のみのルートを生成
  # URL: /weight_setting/edit, /weight_setting
  resource :weight_setting, only: %i[edit update]

  # 【追加】通知時間設定画面のルーティング（単数リソース）
  # resource を使うことで、編集edit と 更新update のみのルートを生成
  # URL: /notification_time_setting/edit, /notification_time_setting
  resource :notification_time_setting, only: %i[edit update]

  # 【追加】パスワード変更画面のルーティング（単数リソース）
  resource :password_setting, only: %i[edit update]

  # お問い合わせページ
  # URL: /contact
  get 'contact', to: 'static_pages#contact'

  # 利用規約ページ
  # URL: /terms
  get 'terms', to: 'static_pages#terms'

  # プライバシーポリシーページ
  # URL: /privacy
  get 'privacy', to: 'static_pages#privacy'
end
