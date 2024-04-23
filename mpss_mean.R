source("concatenateFiles.r")
f.mpss <- list.files("testdata", pattern = ".in2", full.names = T) # provide path of files

timebase <- "10 min"
avg.period <- "1 hour"

for (f in f.mpss) {
    t.mpss <- concatFiles(filelist = f, delim = "\t", colnames = F)

    names(t.mpss) <- c("date", "T", "p", "n_bins", as.character(t.mpss[1, 5:ncol(t.mpss)]))

    t.mpss.prc <- t.mpss %>%
        mutate(datetime = as.POSIXct("2023-01-01 00:00:00 UTC", tz = "UTC") + date * 86400) %>%
        select(-date) %>% # change year to your needs
        filter(row_number() %% 2 == 0) %>%
        mutate(datetime = lubridate::round_date(datetime, timebase)) %>%
        rename("date" = "datetime") %>%
        mutate(date = lubridate::floor_date(date, avg.period)) %>%
        group_by(date) %>%
        summarise_all(.funs = c("mean"), na.rm = T)

    data.table::fwrite(
        x = t.mpss.prc, file = paste0("output/", strsplit(basename(f), ".in2")[1], "_1hmean.in2"),
        col.names = TRUE, row.names = FALSE, append = FALSE, quote = FALSE,sep="\t")
}