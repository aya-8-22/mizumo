// app/javascript/water_intakes.js
// 飲水記録機能の JavaScript

// ページ読み込み時に実行
document.addEventListener('turbo:load', function() {
  
  // 【修正】時刻フィールドに初回のみ現在時刻を設定
  const timeField = document.getElementById('recorded-at-field');
  if (timeField) {
    // 【修正】現在時刻を設定する関数
    function setCurrentTime() {
      // 【修正】現在時刻を取得
      const now = new Date();
      // 【修正】時間を2桁の文字列に変換（例: 9 → 09）
      const hours = String(now.getHours()).padStart(2, '0');
      // 【修正】分を2桁の文字列に変換（例: 5 → 05）
      const minutes = String(now.getMinutes()).padStart(2, '0');
      // 【修正】時刻フィールドに現在時刻を設定（HH:MM形式）
      timeField.value = `${hours}:${minutes}`;
    }
    
    // 【修正】初回のみ現在時刻を設定（自動更新はしない）
    setCurrentTime();
    
    // 【修正】以下の行を削除することで、1秒ごとの自動更新を停止
    // setInterval(updateCurrentTime, 1000); // この行は削除
  }
  
  // すべての水分摂取量ボタンを取得
  const amountButtons = document.querySelectorAll('.amount-btn');
  
  // 各ボタンにクリックイベントを設定
  amountButtons.forEach(button => {
    // 既存のイベントリスナーを削除してから新しいものを追加
    const newButton = button.cloneNode(true);
    button.parentNode.replaceChild(newButton, button);
    
    // ボタンがクリックされたときに実行される処理
    newButton.addEventListener('click', function() {
      // ボタンの data-amount 属性から値を取得
      const amount = this.getAttribute('data-amount');
      
      // 隠しフィールドに値を設定
      document.getElementById('amount-ml-input').value = amount;
      
      // フォームを取得
      const form = document.getElementById('water-intake-form');
      
      // フォームを送信（Turbo が自動的に Ajax 送信してくれる）
      form.requestSubmit();
    });
  });
  
});
