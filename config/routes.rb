# frozen_string_literal: true

# config/routes.rb

# Sidekiq の Web UI を使うために必要なライブラリを読み込む
require 'sidekiq/web'

# 「URL」と「処理（Controller）」をつなぐ仲介役
Rails.application.routes.draw do
  # Sidekiq の Web UI を /sidekiq にマウント
  # ブラウザで http://localhost:3000/sidekiq にアクセスすると管理画面が表示される
  mount Sidekiq::Web => '/sidekiq'

  # get 'password_settings/edit'
  # get 'password_settings/update'
  # get 'notification_time_settings/edit'
  # get 'notification_time_settings/update'
  # get 'weight_settings/edit'
  # get 'weight_settings/update'

  # Devise のルーティングを設定（カスタマイズしたコントローラを使用）
  devise_for :users, controllers: {
    # ログイン機能のコントローラーを指定
    sessions: 'users/sessions',
    # ユーザー登録・更新機能のコントローラーを指定
    registrations: 'users/registrations'
  }

  # Devise のパスをカスタマイズ（ヘッダーで使うパス名に合わせる）
  devise_scope :user do
    # GET /login → ログインページを表示
    # users/sessions コントローラーの new アクションを実行
    get 'login', to: 'users/sessions#new'

    # DELETE /logout → ログアウト処理を実行
    # users/sessions コントローラーの destroy アクションを実行
    delete 'logout', to: 'users/sessions#destroy'

    # GET /users/registration/complete → 登録完了画面を表示
    # users/registrations コントローラーの complete アクションを実行
    # as: :users_registration_complete により、users_registration_complete_path というヘルパーメソッドが生成される
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
  # resources: RESTfulなルーティングを自動生成する
  # only: 使用するアクションだけを指定(index, create, destroy)
  # | index | GET | /water_intakes | 記録一覧を表示 |
  # | create | POST | /water_intakes | 記録を作成 |
  # | destroy | DELETE | /water_intakes/:id | 記録を削除 |
  resources :water_intakes, only: [:index, :create, :destroy]

  # 【修正】開発環境でメールを確認できるようにする
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # ユーザー編集ページのルート（Devise の registrations で管理されるため不要）
  # resources :users, only: [:edit, :update]

  # GET /calendar → カレンダー画面を表示
  # calendars コントローラーの index アクションを実行
  get 'calendar', to: 'calendars#index'

  # 体重設定画面のルーティング（単数リソース）
  # resource を使うことで、編集edit と 更新update のみのルートを生成
  # URL: /weight_setting/edit, /weight_setting
  resource :weight_setting, only: %i[edit update]

  # 通知時間設定画面のルーティング（単数リソース）
  # resource を使うことで、編集edit と 更新update のみのルートを生成
  # URL: /notification_time_setting/edit, /notification_time_setting
  resource :notification_time_setting, only: %i[edit update]

  # パスワード変更画面のルーティング（単数リソース）
  # resource を使うことで、編集edit と 更新update のみのルートを生成
  # URL: /password_setting/edit, /password_setting
  resource :password_setting, only: %i[edit update]

  # 体重設定完了画面のルート
  get 'weight_settings/complete', to: 'weight_settings#complete', as: :weight_settings_complete

  # 通知時間設定完了画面のルート
  get 'notification_time_settings/complete', to: 'notification_time_settings#complete',
                                             as: :notification_time_settings_complete

  # パスワード変更完了画面のルート
  # URL: /password_settings/complete
  # as: :password_settings_complete で password_settings_complete_path というヘルパーメソッドを生成
  get 'password_settings/complete', to: 'password_settings#complete', as: :password_settings_complete

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
