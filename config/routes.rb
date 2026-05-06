# frozen_string_literal: true

# config/routes.rb
# Rails アプリケーションのルーティング（URL とコントローラーの紐付け）を設定するファイル
Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  # 【追加】ルート URL（ / ）にアクセスしたときに home コントローラーの index アクションを実行
  root 'home#index'

  # 【追加】/home/index にアクセスしたときに home コントローラーの index アクションを実行
  get 'home/index'
end
