# app/models/user.rb
# User クラスを定義（ApplicationRecord を継承）
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Devise の認証機能を有効化
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 【追加】体重のバリデーション（空でないこと、数値であり0より大きいことを確認）
  validates :weight, presence: true, numericality: { greater_than: 0 }
end
