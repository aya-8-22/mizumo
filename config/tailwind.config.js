// config/tailwind.config.js
// Webサイトのデザインのルール（色やフォント、画面サイズなど）をカスタマイズするための「Tailwind CSSの設定ファイル」
module.exports = {
  // スキャン対象のファイルを指定
  content: [
    // ビューファイル（erb, haml, html, slim）
    './app/views/**/*.{erb,haml,html,slim}',
    // ヘルパーファイル
    './app/helpers/**/*.rb',
    // JavaScript ファイル
    './app/javascript/**/*.js',
    // 【追加】CSS ファイル
    './app/assets/stylesheets/**/*.css'
  ],
  
  // テーマのカスタマイズ
  theme: {
    extend: {
      // 【変更】ここにカスタムテーマを追加
      colors: {
        // ① 背景（ベース）
        'ivory': '#FDFBF7',
        
        // ② ヘッダー・フッター背景色：ネイビー
        'brand-navy': '#12436D',
        
        // ③ 文字色（テキスト）
        'charcoal': '#222222',
        
        // ④ アクセント
        'brand-orange': '#D85F00',

        // ⑤ ヘッダー・フッターの文字・アイコン色
        'pure-white': '#FFFFFF',
      }
    },
  },
  
  // プラグインの設定
  plugins: [
    // 必要に応じてプラグインを追加
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}