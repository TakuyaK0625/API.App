tabItem_jstage <- tabItem(tabName = "jstage", fluidPage(
  
  actionButton("action", "Apply Filter", style="color: #fff; background-color: #337ab7"),
  downloadButton("downloadData", "Download Table"),
  wellPanel(
      fluidRow(
        column(width = 3, sliderInput("year", "期間", min = 1990, max = 2020, c(2000, 2010))),
        column(width = 9,
               fluidRow(
                   column(width = 3, textInput("inst", "著者所属")),
                   column(width = 3, textInput("auth", "著者名")),
                   column(width = 3, textInput("mat", "資料名")),
                   column(width = 3, textInput("issn", "ISSN: XXXX-XXXX"))),
               fluidRow(
                   column(width = 6, textInput("title", "タイトル検索")),
                   column(width = 6, textInput("text", "全文検索")))
        
  )
)
)
),    

  # メインパネル
           tabsetPanel(
               tabPanel("Table", br(), dataTableOutput("result_table")),
               tabPanel("資料集計", br(), plotlyOutput("plot"), dataTableOutput("material_table"))
           )

  )


