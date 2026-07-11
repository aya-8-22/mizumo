// app/javascript/controllers/application.js
// Stimulus（スティミュラス）というJavaScriptの仕組み全体を動かすための、共通の設定ファイル（初期設定の土台）

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
