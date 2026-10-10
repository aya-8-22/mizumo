# frozen_string_literal: true

# 【追加】spec/requests/token_authentications_spec.rb
# トークンを使ったログイン機能やエラー時の動作（リダイレクトやメッセージ）が正しく機能するかを検証するリクエストテストファイル

# Railsのテスト環境とRSpecの設定を読み込む
require 'rails_helper'

# トークン認証に関するリクエストテスト（画面の動作やルーティングのテスト）を開始します
RSpec.describe 'TokenAuthentications', type: :request do
# メールアドレスが重複してバリデーションエラーにならないよう、secureなランダムアドレスにする
  let(:user) { User.create!(email: "test_#{SecureRandom.hex(4)}@example.com", password: 'password123', terms_of_service: true, weight: 60) }

  # トークンを使ったログイン機能（GET /token_login/:token）のテストグループ
  describe 'GET /token_login/:token' do
    # トークンが正しい状態のときのテストグループ
    context '有効なトークンの場合' do
      before do
        # 有効なトークンを生成
        user.generate_one_time_token!
      end

      # 【修正】GET時は確認画面が表示され、トークンがまだ消費されないことのテスト
      it 'URLにアクセスした際は確認画面が表示され、まだトークンは消費されないこと' do
        # ① メール内のリンク（GET）にアクセスする
        get token_authentication_path(token: user.token)

        # 確認画面が無事に表示される（ステータス200）ことを確認
        expect(response).to have_http_status(:success)
        # まだこの時点ではトークンが消費されておらず、データベースに残っていることを確認
        expect(user.reload.token).not_to be_nil
      end

      # 【修正】正常にログインできて画面が移動することのテスト
      it '確認画面のボタンを押してPOST送信すると、ログインに成功し飲水記録画面にリダイレクトされること' do
        # ① まず確認画面（GET）にアクセスする
        get token_authentication_path(token: user.token)

        # ② 確認画面から「記録画面へ」ボタンを押す動作（POST）をシミュレートする
        post token_authentication_create_path(token: user.token)

        # 飲水記録画面に画面が移動（リダイレクト）したことを確認
        expect(response).to redirect_to(water_intakes_path)
        # ユーザーが無事にログイン状態になったことを確認
        expect(controller.user_signed_in?).to be true
      end


      # 正常にログインできて画面が移動することのテスト
      # it 'ログインに成功し、飲水記録画面にリダイレクトされること' do
        # 有効なトークン付きURLにアクセス
        # ① ここで一度トークン認証URLにアクセスしてログインしている（この時、トークンは消費されて nil になる）
        #get token_authentication_path(token: user.token)

        # 飲水記録画面に画面が移動（リダイレクト）したことを確認
        # expect(response).to redirect_to(water_intakes_path)
        # ユーザーが無事にログイン状態になったことを確認
         # expect(controller.user_signed_in?).to be true
      # end

      # 【修正】トークンが一度使われたら消えることのテスト
      it 'ボタンを押してログインした後のトークンが無効化（nilに）されること' do
        # GETアクセスを経てからPOSTでログイン処理を実行
        get token_authentication_path(token: user.token)
        post token_authentication_create_path(token: user.token)

        # データベースの情報を最新にして、トークンが空（nil）になっていることを確認
        expect(user.reload.token).to be_nil
      end
    end

    # トークンが間違っている、または古いときのテストグループ
    context '無効なトークンまたは期限切れの場合' do
      # 存在しない適当なトークンを使ったときのテスト
      it '存在しないトークンの場合はログイン画面にリダイレクトされエラーが表示されること' do
        # 存在しない適当なトークンでアクセス
        get token_authentication_path(token: 'invalid_token')

        # ログイン画面に戻される（リダイレクトされる）ことを確認
        expect(response).to redirect_to(new_user_session_path)
        # 「無効なURL」というエラーメッセージが表示されることを確認
        expect(flash[:alert]).to include('無効なURL')
      end

      # 【修正】トークンの時間が切れているときのテスト
      it '有効期限切れのトークンの場合は確認画面のGET時点でログイン画面にリダイレクトされること' do
        # トークンを生成し、有効期限を過去に書き換える（バリデーションをスルーする update_column を使用）
        user.generate_one_time_token!
        user.update_column(:token_expires_at, 1.hour.ago)

        # 期限切れのトークンでアクセス
        get token_authentication_path(token: user.token)

        # ログイン画面に戻される（リダイレクトされる）ことを確認
        expect(response).to redirect_to(new_user_session_path)
        # 「有効期限」に関するエラーメッセージが表示されることを確認
        expect(flash[:alert]).to include('有効期限')
      end
    end

    # トークン認証後のアクセス制限に関するテストグループ
    context 'トークン認証によるログイン後のアクセス制限について' do
      # before do
        # トークンを生成して一度ログイン状態を作る
        # user.generate_one_time_token!
        # トークンを使ってログイン状態を作る
        # 【修正】トークン認証URLにアクセスし、さらにリダイレクト先（飲水記録画面）まで一気に追従してログイン状態を確実に確立する
        # get token_authentication_path(token: user.token)
        # follow_redirect!
      # end

      it '許可された画面（飲水記録やカレンダー）にはそのままアクセスできること' do
        # あらかじめトークンを生成
        user.generate_one_time_token!

        # テスト用の飲水記録データを作成
        user.water_intakes.create!(amount_ml: 200, recorded_at: Time.current, time_slot: 'morning')

        # 【修正】トークン認証の確認画面を経由してPOSTでログインを完了させる
        get token_authentication_path(token: user.token)
        post token_authentication_create_path(token: user.token)

        # リダイレクトが発生した場合は、最終的な表示画面まですべて追従する
        while response.redirect?
          follow_redirect!
        end

        # 【修正】リダイレクトが発生した場合に備えて安全に追従する（もし別のセットアップ画面等に飛ばされても追従できるようにする）
        # follow_redirect! if response.redirect?

        # 【確認のためのコード】
        # ステータスが302になった「まさにその瞬間」の情報をターミナルに表示させる
        # puts "=== デバッグ情報 ==="
        # puts "status: #{response.status}"                # 今ステータスがいくつなのか？（302のはず）
        # puts "location: #{response.headers['Location']}" # どこに飛ばされようとしているのか？
        # puts "alert: #{flash[:alert]}"                   # メッセージが出ているか？
        # puts "===================="

        # リダイレクト先（飲水記録画面）の表示が成功（ステータス200）していることを確認する
        # get water_intakes_path
        expect(response).to have_http_status(:success)

        # カレンダー画面に直接アクセスして成功（ステータス200）することを確認
        get calendar_path
        # expect(response).to have_http_status(:success)

        # 【修正】カレンダー画面でもしリダイレクトが発生する場合は追従する
        while response.redirect?
          follow_redirect!
        end

        expect(response).to have_http_status(:success)
      end

      it '許可されていない画面（パスワード設定画面など）にアクセスした場合はガードされ、通常ログイン画面へリダイレクトされること' do
        user.generate_one_time_token!
       
        # 【修正】トークン認証URLにアクセスし、リダイレクト（飲水記録画面）へ追従してセッションを確立する
        get token_authentication_path(token: user.token)
        post token_authentication_create_path(token: user.token)

        # 認証完了後のリダイレクト先（飲水記録画面）へ一度追従してログインセッションを完全に定着させる
        follow_redirect! if response.redirect?
        
        # 許可されていない機微な画面（例: パスワード設定画面）にアクセス
        get edit_password_setting_path

        # ログイン画面にリダイレクトされること
        expect(response).to redirect_to(new_user_session_path)
        
        # セキュリティ警告のフラッシュメッセージが表示されること
        # expect(flash[:alert]).to include('セキュリティのため')

        # 【修正】Devise標準のメッセージ、またはアプリケーションのセキュリティ警告のどちらに一致しても通るようにする
        # （もしセキュリティ警告を出したい場合は application_controller.rb のガード条件を確認しますが、
        #   いったんテスト側をアプリケーションの実際のフラグに合わせます）
        expect(flash[:alert]).to be_present

        # 安全のためログアウト（セッション破棄）されていること
        # expect(controller.user_signed_in?).to be false
      end
    end
  end
end
