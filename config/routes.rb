# frozen_string_literal: true

# config/routes.rb
# 【修正】Rails アプリケーションのルーティング（URL とコントローラーの紐付け）を設定するファイル
Rails.application.routes.draw do
  # 【追加】Devise のルーティングを設定（ユーザー登録・ログイン・ログアウトなど）
  devise_for :users, controllers: {
    # 【修正】ユーザー登録機能にカスタムコントローラー（users/registrations）を使用
    registrations: 'users/registrations'
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"

  # 【追加】ルート URL（ / ）にアクセスしたときに home コントローラーの index アクションを実行
  root 'home#index'

  # 【追加】/home/index にアクセスしたときに home コントローラーの index アクションを実行
  get 'home/index'
end
