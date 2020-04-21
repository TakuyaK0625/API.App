# UI
tabItem_about <- tabItem(tabName = "about",
          
          tabsetPanel(
              tabPanel("はじめに", type = "tabs",
                       h3(strong("はじめに")),
                       p("このアプリはJstage/CiNii Arcicles/CiNii Booksで検索できる論文/書籍/雑誌等の情報を、APIを用いて取得するためのツールです。
                         コードの共有はいたしますが、使用に際しては以下のそれぞれのAPIの利用規約を遵守いただき、利用者の責任においてご利用ください。
                         なお、CiNii Articles/Booksはappidが必要ですので、予めご用意ください"),
                       br(),
                       p("【Jstage APIの利用規約】"),
                       p("https://www.jstage.jst.go.jp/static/pages/WebAPI/-char/ja"),
                       p("【CiNii全般の利用規約】"),
                       p("https://support.nii.ac.jp/ja/cinii/terms"),
                       br(),
                       # 出典
                       h3(strong("出典")),
                       p("「科学技術情報発信・流通総合システム」（J-STAGE）（国立研究開発法人科学技術振興機構）（https://www.jstage.jst.go.jp/browse/-char/ja）"),
                       p("「NII学術情報ナビゲータ」（CiNIi）（国立情報学研究所（NII））（https://ci.nii.ac.jp）"),
                       br(),
                       
                       # 連絡先
                       h4(strong("アプリ作成者")),
                       p("信州大学 学術研究・産学官連携推進機構"),
                       p("久保 琢也"),
                       p("E-mail: kubotaku[AT]shinshu-u.ac.jp"),
                       p("※ご自身の環境でWebアプリ化される場合には上記の署名をご自身のものに書き換えてください。")
                       )
              

              )
          )


