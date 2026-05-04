# config/puma.rb
# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
# スレッド数の最大値を環境変数から取得（デフォルトは5）
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# スレッド数の最小値を環境変数から取得（デフォルトは最大値と同じ）
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
# Pumaが使用するスレッド数の範囲を設定
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
# development環境でのみ、ワーカーのタイムアウトを3600秒に設定
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
# Pumaが待ち受けるポート番号を環境変数から取得（デフォルトは3000）
# Renderでは自動的にPORT環境変数が設定される（通常は10000）
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
# 【変更】Pumaが動作する環境を設定
# 環境変数 RAILS_ENV が設定されていない場合は development、設定されている場合はその値を使用
# 本番環境では Render 側で RAILS_ENV=production を環境変数に設定する
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
# プロセスIDを保存するファイルのパスを設定
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# 【変更】ワーカープロセス数を環境変数から取得（デフォルトは2）
# 複数のワーカーを起動することで並列処理が可能になる
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# 【変更】アプリケーションを事前に読み込んでからワーカーをフォーク
# Copy On Write機能によりメモリ使用量を削減できる
preload_app!

# Allow puma to be restarted by `bin/rails restart` command.
# `bin/rails restart`コマンドでPumaを再起動できるようにする
plugin :tmp_restart
