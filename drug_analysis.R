# Author: Christopher Peters
# Twitter: @statwonk
# Analysis of adverse reported drug events from FDA database

# Data found here: http://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/Surveillance/AdverseDrugEffects/ucm082193.htm

patient <- read.table("~/Downloads/faers_ascii_2012q4/ascii/demo12q4.txt", sep = "$", header = T, fill = T, quote = "")
drug <- read.table("~/Downloads/faers_ascii_2012q4/ascii/drug12q4.txt", sep = "$", header = T, fill = T, quote = "")
reaction <- read.table("~/Downloads/faers_ascii_2012q4/ascii/reac12q4.txt", sep = "$", header = T, fill = T, quote = "")
outcomes <- read.table("~/Downloads/faers_ascii_2012q4/ascii/outc12q4.txt", sep = "$", header = T, fill = T, quote = "")

df <- drug[(grepl("lexapro", drug$drugname, ignore.case = T) | # enter drug names here
        grepl("Escitalopram", drug$drugname, ignore.case = T) | # enter drug names here, add or remove grepl() as needed with "or" statements \
          grepl("cipralex", drug$drugname, ignore.case = T)) & drug$drug_seq == 1, ] # drug seq 1 == suspect drug of many possible that patient is taking

df <- merge(df, reaction, by = "primaryid") # let's merge the drug file with reactions
df <- merge(df, outcomes, by = "primaryid")


df2 <- as.data.frame(table(df$pt, df$outc_code))
names(df2) <- c("reaction", "outcome", "count")
df2 <- df2[order(df2$count, decreasing = T), ]
head(df2, 20) # top 20 reactions

