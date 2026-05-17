//【追加】config/tailwind.config.js
// Tailwind CSS の設定ファイル
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
      // ここにカスタムテーマを追加
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