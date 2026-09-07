// app/javascript/password_toggle.js
// パスワード表示/非表示の切り替え機能

// パスワード表示機能を初期化する関数を定義
function initPasswordToggle() {
  // チェックボックスの要素を取得
  const showPasswordCheckbox = document.getElementById('show-password');

  // 要素が存在しない場合は処理を終了（他のページでエラーを防ぐため）
  if (!showPasswordCheckbox) {
    return;
  }

  // ページ読み込み時にチェックボックスの状態を必ずリセット
  showPasswordCheckbox.checked = false;

  // ログイン画面のパスワード入力欄を取得
  const loginPasswordField = document.getElementById('password-field');

  // 新規登録画面のパスワード入力欄を取得
  const registerPasswordField = document.getElementById('register-password-field');
  // 新規登録画面のパスワード確認入力欄を取得
  const registerPasswordConfirmationField = document.getElementById('register-password-confirmation-field');

  // 【修正】パスワード変更画面の現在のパスワード入力欄を取得
  const currentPasswordField = document.getElementById('current-password-field');
  // 【修正】パスワード変更画面の新しいパスワード入力欄を取得
  const newPasswordField = document.getElementById('new-password-field');
  // 【修正】パスワード変更画面の新しいパスワード確認入力欄を取得
  const newPasswordConfirmationField = document.getElementById('new-password-confirmation-field');

  // ページ読み込み時にログイン画面のパスワードフィールドを非表示に戻す
  if (loginPasswordField) {
    loginPasswordField.type = 'password';
  }

  // ページ読み込み時に新規登録画面のパスワードフィールドを非表示に戻す
  if (registerPasswordField) {
    registerPasswordField.type = 'password';
  }

  // ページ読み込み時に新規登録画面のパスワード確認フィールドを非表示に戻す
  if (registerPasswordConfirmationField) {
    registerPasswordConfirmationField.type = 'password';
  }

  // 【修正】ページ読み込み時にパスワード変更画面の現在のパスワードフィールドを非表示に戻す
  if (currentPasswordField) {
    currentPasswordField.type = 'password';
  }

  // 【修正】ページ読み込み時にパスワード変更画面の新しいパスワードフィールドを非表示に戻す
  if (newPasswordField) {
    newPasswordField.type = 'password';
  }

  // 【修正】ページ読み込み時にパスワード変更画面の新しいパスワード確認フィールドを非表示に戻す
  if (newPasswordConfirmationField) {
    newPasswordConfirmationField.type = 'password';
  }

  // 既存のイベントリスナーを削除してから新しいものを追加（重複を防ぐ）
  const newCheckbox = showPasswordCheckbox.cloneNode(true);
  showPasswordCheckbox.parentNode.replaceChild(newCheckbox, showPasswordCheckbox);

  // チェックボックスがクリックされたときの処理
  newCheckbox.addEventListener('change', function() {
    // チェックボックスがチェックされている場合
    if (this.checked) {
      // ログイン画面のパスワード入力欄を表示
      if (loginPasswordField) {
        loginPasswordField.type = 'text';
      }
      // 新規登録画面のパスワード入力欄を表示
      if (registerPasswordField) {
        registerPasswordField.type = 'text';
      }
      // 新規登録画面のパスワード確認入力欄を表示
      if (registerPasswordConfirmationField) {
        registerPasswordConfirmationField.type = 'text';
      }
      // 【修正】パスワード変更画面の現在のパスワード入力欄を表示
      if (currentPasswordField) {
        currentPasswordField.type = 'text';
      }
      // 【修正】パスワード変更画面の新しいパスワード入力欄を表示
      if (newPasswordField) {
        newPasswordField.type = 'text';
      }
      // 【修正】パスワード変更画面の新しいパスワード確認入力欄を表示
      if (newPasswordConfirmationField) {
        newPasswordConfirmationField.type = 'text';
      }
    } else {
      // チェックボックスがチェックされていない場合
      // ログイン画面のパスワード入力欄を非表示
      if (loginPasswordField) {
        loginPasswordField.type = 'password';
      }
      // 新規登録画面のパスワード入力欄を非表示
      if (registerPasswordField) {
        registerPasswordField.type = 'password';
      }
      // 新規登録画面のパスワード確認入力欄を非表示
      if (registerPasswordConfirmationField) {
        registerPasswordConfirmationField.type = 'password';
      }
      // 【修正】パスワード変更画面の現在のパスワード入力欄を非表示
      if (currentPasswordField) {
        currentPasswordField.type = 'password';
      }
      // 【修正】パスワード変更画面の新しいパスワード入力欄を非表示
      if (newPasswordField) {
        newPasswordField.type = 'password';
      }
      // 【修正】パスワード変更画面の新しいパスワード確認入力欄を非表示
      if (newPasswordConfirmationField) {
        newPasswordConfirmationField.type = 'password';
      }
    }
  });
}

// ページが読み込まれたときに実行
document.addEventListener('turbo:load', initPasswordToggle);

// フォームが再表示されたときにも実行（ログイン失敗時など）
document.addEventListener('turbo:render', initPasswordToggle);