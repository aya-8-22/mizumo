// 【追加】app/javascript/notification_toggle.js
// 設定（メール通知）画面のトグルボタンのテキスト切り替え機能

// 通知トグル機能を初期化する関数を定義
function initNotificationToggle() {
  // 全てのトグルチェックボックスを取得
  const toggleCheckboxes = document.querySelectorAll('.toggle-checkbox');

  // 要素が存在しない場合は処理を終了（他のページでエラーを防ぐため）
  if (toggleCheckboxes.length === 0) {
    return;
  }

  // 各チェックボックスにイベントリスナーを追加
  toggleCheckboxes.forEach(function(checkbox) {
    // data-target 属性からテキスト要素のIDを取得
    const targetId = checkbox.dataset.target;
    // テキスト要素を取得
    const textElement = document.getElementById(targetId);

    // テキスト要素が存在しない場合はスキップ
    if (!textElement) {
      return;
    }

    // チェックボックスがクリックされたときの処理
    checkbox.addEventListener('change', function() {
      // チェックボックスがチェックされている場合
      if (this.checked) {
        // テキストを「通知有」に変更
        textElement.textContent = '通知有';
      } else {
        // テキストを「通知無」に変更
        textElement.textContent = '通知無';
      }
    });
  });
}

// ページが読み込まれたときに実行
document.addEventListener('turbo:load', initNotificationToggle);

// フォームが再表示されたときにも実行
document.addEventListener('turbo:render', initNotificationToggle);