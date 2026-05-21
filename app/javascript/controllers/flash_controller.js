// 【追加】app/javascript/controllers/flash_controller.js
// フラッシュメッセージを自動で削除するStimulusコントローラー
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // data-flash-target="message" で指定した要素を取得
  static targets = ["message"]

  // コントローラーが読み込まれた時に実行
  connect() {
    // 3秒後にフラッシュメッセージを削除
    setTimeout(() => {
      this.messageTarget.remove()
    }, 3000)
  }
}