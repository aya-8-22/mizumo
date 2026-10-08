# frozen_string_literal: true

# 【追加】app/models/contact.rb
# お問い合わせのデータ構造の定義、入力値のバリデーション（検証）、およびデータベース操作を行うモデル（Model）

# データベースに保存しないお問い合わせ用のモデルクラスを定義しています
class Contact
  # ActiveModelのバリデーションやフォーム機能を有効にするモジュールを読み込んでいます
  include ActiveModel::Model
  # 属性（データを一時的に保持する場所）を定義できるようにするモジュールを読み込んでいます
  include ActiveModel::Attributes

  # お名前を保持する属性を文字列型で定義しています
  attribute :name, :string
  # メールアドレスを保持する属性を文字列型で定義しています
  attribute :email, :string
  # ご本人様との関係を保持する属性を文字列型で定義しています
  attribute :relationship, :string
  # お問い合わせの種類を保持する属性を文字列型で定義しています
  attribute :category, :string
  # お問い合わせの詳細内容を保持する属性を文字列型で定義しています
  attribute :message, :string
  # 利用規約への同意状態を保持する属性を真偽値型で定義しています
  attribute :terms_of_service, :boolean

  # お名前が空欄になっていないかをチェックするバリデーションを設定しています
  validates :name, presence: true
  # メールアドレスが空欄でないことと、正しいメールアドレスの形式であるかをチェックするバリデーションを設定しています
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  # ご本人様との関係が選択されているかをチェックするバリデーションを設定しています
  validates :relationship, presence: true
  # 問い合わせの種類が選択されているかをチェックするバリデーションを設定しています
  validates :category, presence: true
  # 詳細内容が空欄でないことと、文字数が最大200文字以内であることをチェックするバリデーションを設定しています
  validates :message, presence: true, length: { maximum: 200 }
  # 利用規約にチェックが入っていることを確認するバリデーションを設定しています
  validates :terms_of_service, acceptance: true
end
