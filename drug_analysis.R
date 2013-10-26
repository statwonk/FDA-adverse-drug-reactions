# Author: Christopher Peters
# Twitter: @statwonk
# Analysis of adverse reported drug events from FDA database

# Data found here: http://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/Surveillance/AdverseDrugEffects/ucm082193.htm

patient <- read.table("~/Downloads/faers_ascii_2012q4/ascii/demo12q4.txt", sep = "$", header = T, fill = T, quote = "")
drug <- read.table("~/Downloads/faers_ascii_2012q4/ascii/drug12q4.txt", sep = "$", header = T, fill = T, quote = "")
reaction <- read.table("~/Downloads/faers_ascii_2012q4/ascii/reac12q4.txt", sep = "$", header = T, fill = T, quote = "")
outcomes <- read.table("~/Downloads/faers_ascii_2012q4/ascii/outc12q4.txt", sep = "$", header = T, fill = T, quote = "")

# You can find individual drugs and their reported adverse by specifying there names below

# There are commonly many names for a drug, see below where I put three grepl statements
# with text like, "put drug brand name here", you can replace this with drug brand names
# you can add or remote grepl statements depending on the number of brand names you want to look over.

df <- drug[(grepl("put drug brand name 1 here", drug$drugname, ignore.case = T) | # drug is likely to be entered as many different brand names, use this to capture them individually
              grepl("put drug brand name 2 here", drug$drugname, ignore.case = T) | # enter drug names here, add or remove grepl() as needed with "or" statements \
              grepl("put drug brand name 3 here ... add more grepl statements as necessary", drug$drugname, ignore.case = T)) & drug$drug_seq == 1, ] # drug seq 1 == suspect drug of many possible that patient is taking

df <- merge(df, reaction, by = "primaryid") # let's merge the drug file with reactions
df <- merge(df, outcomes, by = "primaryid") # we'll bring in outcomes, too
df2 <- as.data.frame(table(df$pt, df$outc_code)) # count the instances of reactions and their outcomes
names(df2) <- c("reaction", "outcome", "count")
df2 <- df2[order(df2$count, decreasing = T), ]
head(df2, 20) # top 20 reactions