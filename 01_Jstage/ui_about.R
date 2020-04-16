# UI
tabItem_about <- tabItem(tabName = "about",
          
          tabsetPanel(
              tabPanel("はじめに", type = "tabs",
                       h3(strong("はじめに")),
                       p("このアプリはJstage APIを用いて検索した論文リストの集計、ダウンロードなどができるツールです。
                         コードの共有はいたしますが、使用に際しては以下のJstage APIの利用規約をご確認いただき、利用者の
                         責任でご利用ください。"),
                       br(),
                       p("https://www.jstage.jst.go.jp/static/pages/WebAPI/-char/ja"),
                       br(),
                       
                       # 出典
                       h3(strong("出典")),
                       p("「科学技術情報発信・流通総合システム」（J-STAGE）（国立研究開発法人科学技術振興機構）（https://www.jstage.jst.go.jp/browse/-char/ja）をもとに作成"),
                       br(),
                       
                       # 連絡先
                       h4(strong("連絡先")),
                       p("信州大学 学術研究・産学官連携推進機構"),
                       p("久保 琢也"),
                       p("E-mail: kubotaku[AT]shinshu-u.ac.jp"),
                       p("※個人の責任でWebアプリされる場合には上記の署名を書き換えてください。")
                       )
              

              )
          )


