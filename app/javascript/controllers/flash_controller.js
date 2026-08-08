// app/javascript/controllers/flash_controller.js
// フラッシュメッセージの自動消去を制御するStimulusコントローラー

import { Controller } from "@hotwired/stimulus"

// Stimulus コントローラーを継承したクラスを定義
export default class extends Controller {
  // ターゲットを定義（HTML要素を参照するため）
  static targets = ["message"]
  
  // 値を定義（HTML要素からデータを受け取るため）
  static values = {
    autoClose: Boolean // 自動消去するかどうか（true/false）
  }

  // コントローラーがDOMに接続されたときに実行されるメソッド
  connect() {
    // autoCloseValueがtrueの場合のみ自動消去を実行
    if (this.autoCloseValue) {
      // 【修正】5秒後に自動消去を実行
      this.timeout = setTimeout(() => {
        this.close()
      }, 5000) // 5000ミリ秒 = 5秒
    }
  }

  // コントローラーがDOMから切断されたときに実行されるメソッド
  disconnect() {
    // タイムアウトをクリア（メモリリーク防止）
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  // フラッシュメッセージを閉じるメソッド
  close() {
    // フェードアウトアニメーションを追加
    this.messageTarget.style.transition = "opacity 0.3s"
    this.messageTarget.style.opacity = "0"
    
    // アニメーション完了後に要素を削除
    setTimeout(() => {
      this.messageTarget.remove()
    }, 300) // 300ミリ秒後に削除
  }
}