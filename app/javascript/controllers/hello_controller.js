// app/javascript/controllers/hello_controller.js
// Stimulus（スティミュラス）という仕組みを使った、JavaScriptの動きを定義するための『サンプルの部品』

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
