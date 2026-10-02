// 【修正】app/javascript/contact_counter.js
// ログイン前後やバリデーションエラー後の再描画でも確実に動作するように関数化する
const initContactCounter = () => {
  // お問い合わせ詳細のテキストエリア要素を取得する
  const textarea = document.getElementById("contact_message");
  // 残り文字数を表示する要素を取得する
  const countDisplay = document.getElementById("char-count");

  // テキストエリアが存在する場合のみ処理を行う
  if (textarea && countDisplay) {
    // 最大文字数を200文字に設定する
    const maxLength = 200;

    // 現在の入力文字数に基づいてカウンターの表示とスタイルを更新する関数
    const updateCounterDisplay = () => {
      const currentLength = [...textarea.value].length;
      const remaining = maxLength - currentLength;

      // 画面の表示を残り文字数に合わせて更新する
      countDisplay.textContent = `残り ${remaining} 文字`;

      // 残り文字数が0になった場合の赤色警告クラスの切り替え
      if (remaining === 0) {
        countDisplay.classList.add("text-red-500");
        countDisplay.classList.remove("text-gray-500");
      } else {
        countDisplay.classList.remove("text-red-500");
        countDisplay.classList.add("text-gray-500");
      }
    };

    // 【修正】ページ読み込み時やバリデーションエラー後の再描画時に、初期状態（すでに入力されている文字数）を反映する
    updateCounterDisplay();

    // 文字数が変更された（入力された）ときの処理を設定する
    textarea.addEventListener("input", () => {
      // 200文字を超えて入力された場合に、200文字目以降を切り捨てる処理
      if ([...textarea.value].length > maxLength) {
        // スプレッド構文を使ってサロゲートペア（絵文字や一部の特殊文字）を考慮しつつ200文字に切り詰める
        textarea.value = [...textarea.value].slice(0, maxLength).join("");
      }
    
      // カウンターの表示とスタイルを更新する
      updateCounterDisplay();
    });
  }
};

// 【修正】RailsのTurbo環境での遷移、通常のページ読み込み、およびTurboによるバリデーションエラー再描画（turbo:render）のすべてに対応させる
document.addEventListener("turbo:load", initContactCounter);
document.addEventListener("DOMContentLoaded", initContactCounter);
document.addEventListener("turbo:render", initContactCounter);