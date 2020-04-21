tabItem_cinii_B <- tabItem(tabName = "cinii_B", fluidPage(
  
  actionButton("action.cinii.B", "Apply Filter", style="color: #fff; background-color: #337ab7"),
  downloadButton("download.cinii.B", "Download Table"),
  
  wellPanel(
      fluidRow(
        column(width = 3, 
               sliderInput("year.cinii.B", "期間", min = 1990, max = 2020, c(2000, 2010)),
               textInput("appid.cinii.B", "APIキー（※必須）")
               ),
        column(width = 9, 
               fluidRow(
                   column(width = 3, textInput("auth.cinii.B", "著者名")),
                   column(width = 3, textInput("publisher.cinii.B", "出版社")),
                   column(width = 2, textInput("issn.cinii.B", "ISSN")),
                   column(width = 2, textInput("isbn.cinii.B", "ISBN")),
                   column(width = 2, textInput("gmd.cinii.B", "資料種別"))
                   ),
               fluidRow(
                   column(width = 6, textInput("title.cinii.B", "資料名検索")),
                   column(width = 6, textInput("text.cinii.B", "フリーワード")))
               )
        )
      )
  ),    

  # メインパネル
  tabsetPanel(
    tabPanel("論文一覧",
             br(),
             dataTableOutput("table.cinii.B")
             )
    )
  )


