tabItem_cinii_A <- tabItem(tabName = "cinii_A", fluidPage(
  
  actionButton("action.cinii.A", "Apply Filter", style="color: #fff; background-color: #337ab7"),
  downloadButton("download.cinii.A", "Download Table"),
  
  wellPanel(
      fluidRow(
        column(width = 3, 
               sliderInput("year.cinii.A", "期間", min = 1990, max = 2020, c(2000, 2010)),
               textInput("appid.cinii.A", "APIキー（※必須）")
               ),
        column(width = 9, 
               fluidRow(
                   column(width = 3, textInput("inst.cinii.A", "著者所属")),
                   column(width = 3, textInput("auth.cinii.A", "著者名")),
                   column(width = 3, textInput("journal.cinii.A", "資料名")),
                   column(width = 3, textInput("issn.cinii.A", "ISSN: XXXX-XXXX"))
                   ),
               fluidRow(
                   column(width = 6, textInput("title.cinii.A", "タイトル検索")),
                   column(width = 6, textInput("text.cinii.A", "フリーワード")))
               )
        )
      )
  ),    

  # メインパネル
  tabsetPanel(
    tabPanel("論文一覧",
             br(),
             dataTableOutput("table.cinii.A")
             )
    )
  )


