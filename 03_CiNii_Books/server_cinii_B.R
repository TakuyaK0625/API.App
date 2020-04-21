observeEvent(input$action.cinii.B, {

# ------------------------------------
# 必要項目のインプットがあるかチェック
# ヒット数をチェック
# ------------------------------------
    

res <- reactive({
     
     req(input$appid.cinii.B)
     req(input$publisher.cinii.B != "" |
             input$text.cinii.B != "" | 
             input$title.cinii.B != "" |
             input$auth.cinii.B != "" |
             input$issn.cinii.B != "" |
             input$isbn.cinii.B != "" |
             input$gmd.cinii.B != "")
     
     GET("https://ci.nii.ac.jp/books/opensearch/search?", 
        query = list(publisher = input$publisher.cinii.B, 
                     year_from = input$year.cinii.B[1], 
                     year_to = input$year.cinii.B[2],
                     q = input$text.cinii.B,
                     title = input$title.cinii.B,
                     author = input$auth.cinii.B,
                     isbn = input$isbn.cinii.B,
                     issn = input$issn.cinii.B,
                     gmd = input$gmd.cinii.B,
                     format = "json", 
                     count = 200, 
                     start = 1,
                     appid = input$appid.cinii.B))
})

res.text <- content(res(), as = "text")
res.json <- fromJSON(res.text) 
num_rec <- res.json$`@graph`$`opensearch:totalResults` %>% as.integer


# ------------------------------------
# レコード数が0の際の処理
# ------------------------------------

# メッセージ
if(num_rec == 0){
    showModal(modalDialog(title = "Error", "No record Matched"))
}

# 以降の処理をストップ
req(num_rec > 0)


# ------------------------------------
# forループで論文情報を取得
# ------------------------------------


# 初期設定
start <- c(0:floor(num_rec/200)) * 200 + 1
DF <- data.frame()

withProgress(message = "Now processing...", value = 0, {    
# リピート開始
for(i in start){

    # APIによりデータの取得
    res <- reactive({
        GET("https://ci.nii.ac.jp/books/opensearch/search?", 
            query = list(publisher = input$publisher.cinii.B, 
                         year_from = input$year.cinii.B[1], 
                         year_to = input$year.cinii.B[2],
                         q = input$text.cinii.B,
                         title = input$title.cinii.B,
                         author = input$auth.cinii.B,
                         isbn = input$isbn.cinii.B,
                         issn = input$issn.cinii.B,
                         gmd = input$gmd.cinii.B,
                         format = "json", 
                         count = 200, 
                         start = i,
                         appid = input$appid.cinii.B))
    })
    
    res.text <- content(res(), as = "text")
    res.json <- fromJSON(res.text)
    
    df <- res.json[[2]][[4]][[1]] %>% 
        select(著者 = `dc:creator`, 書誌名 = title, 出版社 = `dc:publisher`, 出版日 = `dc:date`, リンク = `@id`,  `ISBN/ISSN` = `dcterms:hasPart`, 所蔵館数 = `cinii:ownerCount`)
    
    df <- df %>%
        mutate(出版社 = map(出版社, paste0, collapse = "/") %>% unlist) %>%
        mutate(`ISBN/ISSN` =  map(`ISBN/ISSN`, function(x){unlist(x) %>% paste0(collapse = "/")}) %>% unlist)
    
    DF <- rbind(DF, df)
    incProgress(200/num_rec)
    }
})

# テーブルで表示
output$table.cinii.B <- renderDataTable(
    datatable(DF, rownames = F)
)

# ダウンロード機能
output$download.cinii.B <- downloadHandler(
    filename = paste0("cinii_books_download_", Sys.Date(), ".csv"),
    content = function(file) {
        write.csv(DF, file, row.names = FALSE, fileEncoding = "CP932")
    }
)

})
