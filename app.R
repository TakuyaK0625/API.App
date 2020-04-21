# -------------------------------------------------------
# Environment
# -------------------------------------------------------


source("global.R", local = TRUE)
source("00_About/ui_about.R", local = TRUE)
source("01_Jstage/ui_jstage.R", local = TRUE)
source("02_CiNIi_Articles/ui_cinii_A.R", local = TRUE)
source("03_CiNIi_Books/ui_cinii_B.R", local = TRUE)


# --------------------------------
# User Interface
# --------------------------------


ui <- dashboardPage(
    dashboardHeader(title = "APIアプリ"),
    dashboardSidebar(sidebarMenu(
        menuItem("0. About", tabName = "about"),
        menuItem("1. Jstage", tabName = "jstage"),
        menuItem("2. CiNii Articles", tabName = "cinii_A"),
        menuItem("3. CiNii Books", tabName = "cinii_B")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem_about,
            tabItem_jstage,
            tabItem_cinii_A,
            tabItem_cinii_B
            )
        )
    )


# --------------------------------
# Server
# --------------------------------

server <- function(input, output, session) {
    
    source("01_Jstage/server_jstage.R", local = TRUE)
    source("02_CiNii_Articles/server_cinii_A.R", local = TRUE)
    source("03_CiNii_Books/server_cinii_B.R", local = TRUE)
    
}


# --------------------------------
# Run App!
# --------------------------------

shinyApp(ui, server)
