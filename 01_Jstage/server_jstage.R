observeEvent(input$action, { 
    
# ------------------------------
# ループのためにレコード数を取得
# ------------------------------
    
res <- reactive({
  
  req(!(input$inst == "")|!(input$auth == "")|!(input$mat == "")|!(input$issn == "")|!(input$title == "")|!(input$text == ""))


    # API
    GET("http://api.jstage.jst.go.jp/searchapi/do",
        query = list(service = 3, 
                     pubyearfrom = input$year[1], 
                     pubyearto = input$year[2],
                     affil = input$inst,
                     author = input$auth,
                     material = input$mat,
                     issn = input$issn,
                     article = input$title,
                     text = input$text)
        )
    })

#　xml形式に変換
xml <- res() %>% content("parsed", encoding = "UTF-8")

# レコード数の取得
num_rec <- xml %>% xml_find_all(".//*[name() = 'opensearch:totalResults']") %>% xml_text %>% as.numeric

# リピート数ベクトル
if (!is.na(num_rec)){
    num_rep <- 1:ceiling(num_rec/1000)
    } else {  
    num_rep <- 1 }

# ------------------------------
# ループを実行し、データを取得
# ------------------------------

    
# 空データフレーム
DF <- data.frame()

withProgress(message = "Now processing...", value = 0, {    
  
# ループ開始
for(i in 1 + 1000 * (num_rep - 1)){
        
    res <- reactive({
        
        req(!is.na(num_rec))
        
        GET("http://api.jstage.jst.go.jp/searchapi/do",
            query = list(service = 3, 
                         pubyearfrom = input$year[1], 
                         pubyearto = input$year[2],
                         affil = input$inst,
                         author = input$auth,
                         material = input$mat,
                         issn = input$issn,
                         article = input$title,
                         text = input$text,
                         count = 1000,
                         start = i)
            )
    })
    
    #　xml形式に変換
    xml <- res() %>% content("parsed", encoding = "UTF-8") %>% xml_find_all(".//*[name()='entry']")
    
    # 各レコードから必要な情報を抽出
    d <- data.frame()
        
        for(j in 1:length(xml)){
            
            # 日本語タイトル
            title_ja <- xml[j] %>% xml_find_first(".//*[name()='article_title']") %>% xml_find_first(".//*[name()='ja']") %>% xml_text
            # 英語タイトル
            title_en <- xml[j] %>% xml_find_first(".//*[name()='article_title']") %>% xml_find_first(".//*[name()='en']") %>% xml_text
            # 出版年
            year <- xml[j] %>% xml_find_first(".//*[name()='pubyear']") %>% xml_text
            # 日本語資料名
            mat_ja <- xml[j] %>% xml_find_first(".//*[name()='material_title']") %>% xml_find_first(".//*[name()='ja']") %>% xml_text
            # 英語資料名
            mat_en <- xml[j] %>% xml_find_first(".//*[name()='material_title']") %>% xml_find_first(".//*[name()='en']") %>% xml_text
            # DOI
            doi <- xml[j] %>% xml_find_first(".//*[name()='prism:doi']") %>% xml_text
            # リンク
            link <- xml[j] %>% xml_find_first(".//*[name()='article_link']") %>% xml_find_first(".//*[name()='ja']") %>% xml_text
            
            # データフレーム化
            d <- rbind(d, data.frame(title_ja, title_en, mat_ja, mat_en, doi, year, link))
            
            incProgress(1/num_rec)
        }
    
    DF <- rbind(DF, d)
        
}
})

# データの整理
finalDF <- DF %>% 
    mutate(title_ja = as.character(title_ja), title_en = as.character(title_en)) %>%
    mutate(mat_ja = as.character(mat_ja), mat_en = as.character(mat_en)) %>%
    mutate(論文タイトル = ifelse(title_ja != "", title_ja, title_en)) %>%
    mutate(資料名 = ifelse(mat_ja != "", mat_ja, mat_en)) %>%
    select(出版年 = year, 論文タイトル, 資料名, DOI = doi, Link = link)


# 論文一覧テーブル
output$result_table <- renderDataTable({
    
        finalDF %>% datatable(rownames = FALSE)
    
        })

# 資料名サマリープロット
output$plot <- renderPlotly({
  finalDF %>% 
    group_by(資料名) %>%
    summarize(N = n()) %>%
    filter(N > 2) %>%
    plot_ly(y = ~reorder(資料名, N), x = ~N, type = "bar", orientation = "h") %>%
    layout(xaxis = list(title = "論文数"), yaxis = list(title = "資料名"))
})

# 資料名サマリーテーブル
output$material_table <- renderDataTable({
  finalDF %>% 
    group_by(資料名) %>%
    summarize(N = n()) %>%
    arrange(-N) %>%
    datatable(rownames = FALSE)
})


    
# 集計表のダウンロード
output$downloadData <- downloadHandler(
        filename = paste0("jstage_download_", Sys.Date(), ".csv"),
        content = function(file) {
            write.csv(finalDF, file, row.names = FALSE, fileEncoding = "CP932")
            }
        )
    
})
