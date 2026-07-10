// app/javascript/application.js
// Webサイトに動きやインタラクティブな機能を追加するための、JavaScriptプログラムの司令塔（玄関口）

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// Turbo Rails を読み込む（ページ遷移を高速化）
import "@hotwired/turbo-rails"
// Stimulus コントローラーを読み込む
import "controllers"

// ===== 【追加】以下のコードを追加 =====
document.addEventListener('DOMContentLoaded', function() {
  // 「パスワードを表示する」チェックボックスを取得
  const showPasswordCheckbox = document.getElementById('show-password');
  // パスワード入力欄を取得
  const passwordField = document.getElementById('password-field');
  // パスワード確認入力欄を取得
  const passwordConfirmationField = document.getElementById('password-confirmation-field');
  
  // チェックボックスが存在する場合のみ処理を実行
  if (showPasswordCheckbox) {
    // チェックボックスの状態が変わったときの処理
    showPasswordCheckbox.addEventListener('change', function() {
      // チェックされていたら 'text'（表示）、されていなければ 'password'（非表示）
      const type = this.checked ? 'text' : 'password';
      // パスワード入力欄の type 属性を変更
      if (passwordField) passwordField.type = type;
      // パスワード確認入力欄の type 属性を変更
      if (passwordConfirmationField) passwordConfirmationField.type = type;
    });
  }
  
  // 利用規約チェックボックスを取得
  const termsCheckbox = document.getElementById('terms-checkbox');
  // 登録ボタンを取得
  const registerButton = document.getElementById('register-button');
  // メールアドレス入力欄を取得【修正】
  const emailField = document.querySelector('input[type="email"]');
  
  // 登録ボタンの有効/無効を判定する関数
  function updateRegisterButtonState() {
    // メールアドレスが入力されているか
    const isEmailFilled = emailField && emailField.value.trim() !== '';
    // パスワードが入力されているか
    const isPasswordFilled = passwordField && passwordField.value.trim() !== '';
    // パスワード確認が入力されているか
    const isPasswordConfirmationFilled = passwordConfirmationField && passwordConfirmationField.value.trim() !== '';
    // 利用規約にチェックが入っているか
    const isTermsChecked = termsCheckbox && termsCheckbox.checked;
    
    // すべての条件を満たしている場合のみボタンを有効化
    if (registerButton) {
      registerButton.disabled = !(isEmailFilled && isPasswordFilled && isPasswordConfirmationFilled && isTermsChecked);
    }
  }
  
  // メールアドレス入力欄が存在する場合
  if (emailField) {
    // 入力内容が変わるたびに登録ボタンの状態を更新
    emailField.addEventListener('input', updateRegisterButtonState);
  }
  // パスワード入力欄が存在する場合
  if (passwordField) {
    // 入力内容が変わるたびに登録ボタンの状態を更新
    passwordField.addEventListener('input', updateRegisterButtonState);
  }
  // パスワード確認入力欄が存在する場合
  if (passwordConfirmationField) {
    // 入力内容が変わるたびに登録ボタンの状態を更新
    passwordConfirmationField.addEventListener('input', updateRegisterButtonState);
  }
  // 利用規約チェックボックスが存在する場合
  if (termsCheckbox) {
    // チェック状態が変わるたびに登録ボタンの状態を更新
    termsCheckbox.addEventListener('change', updateRegisterButtonState);
  }
  
  // ページ読み込み時にも登録ボタンの状態を更新（初期状態を反映）
  updateRegisterButtonState();
});
