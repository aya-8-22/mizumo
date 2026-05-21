# config/initializers/session_store.rb

# セッションストアの設定
Rails.application.config.session_store :cookie_store,
                                       # セッションCookieの名前を設定
                                       key: '_your_app_session',
                                       # 【重要】expire_after を nil に設定することで、ブラウザを閉じたらセッションが破棄される
                                       expire_after: nil
