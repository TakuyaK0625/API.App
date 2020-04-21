observeEvent(input$action.cinii.A, {


# ------------------------------------
# 必要項目のインプットがあるかチェック
# ヒット数をチェック
# ------------------------------------
    
    
res <- reactive({
     
     req(input$appid.cinii.A)
     req(input$inst.cinii.A != "" | 
             input$text.cinii.A != "" | 
             input$title.cinii.A != "" | 
             input$auth.cinii.A != "" | 
             input$issn.cinii.A != "" | 
             input$journal.cinii.A != "")
     
     GET("http://ci.nii.ac.jp/opensearch/search?", 
        query = list(affiliation = input$inst.cinii.A, 
                     year_from = input$year.cinii.A[1], 
                     year_to = input$year.cinii.A[2],
                     q = input$text.cinii.A,
                     title = input$title.cinii.A,
                     author = input$auth.cinii.A,
                     issn = input$issn.cinii.A,
                     journal = input$journal.cinii.A,
                     format = "json", 
                     count = 200, 
                     start = 1,
                     appid = input$appid.cinii.A))
})

res.text <- content(res(), as = "text")
res.json <- fromJSON(res.text) 
num_rec <- res.json[[3]][[7]] %>% as.integer


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
        GET("http://ci.nii.ac.jp/opensearch/search?", 
               query = list(affiliation = input$inst.cinii.A, 
                            year_from = input$year.cinii.A[1], 
                            year_to = input$year.cinii.A[2],
                            q = input$text.cinii.A,
                            title = input$title.cinii.A,
                            author = input$auth.cinii.A,
                            issn = input$issn.cinii.A,
                            journal = input$journal.cinii.A,
                            format = "json", 
                            count = "200", 
                            start = i,
                            appid = input$appid.cinii.A))
    })
    
    res.text <- content(res(), as = "text")
    res.json <- fromJSON(res.text)
    
    df <- res.json$`@graph`$items[[1]]
    df <- df %>% mutate(著者 = map(`dc:creator`, function(x){paste(x$`@value`, collapse = ", ") %>% unlist}))
    df <- df %>%
        select(著者, 論文タイトル = title, 資料名 = `prism:publicationName`, 出版社 = `dc:publisher`, ISSN = `prism:issn`, 出版日 = `dc:date`, リンク = `@id`)

    DF <- rbind(DF, df)
    incProgress(200/num_rec)
    }
})

output$table.cinii.A <- renderDataTable(
    datatable(DF, rownames = F)
)

output$download.cinii.A <- downloadHandler(
    filename = paste0("cinii_download_", Sys.Date(), ".csv"),
    content = function(file) {
        write.csv(as.data.frame(lapply(DF,unlist)), file, row.names = FALSE, fileEncoding = "CP932")
    }
)


})
