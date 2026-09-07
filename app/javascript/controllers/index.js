// app/javascript/controllers/index.js
// Webサイト内の動き（JavaScript）を担当する部品（コントローラー）を、一括で読み込んで登録するための『管理リスト』

// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
