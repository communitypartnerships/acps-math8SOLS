# ==============================================================================
# Project:     Canter for Community Partnerships VDOE Data Integration Pipeline
# Script:      CCP_VDOE_data_integration_pipeline.R
# Author:      Emily McMahon, Graduate Research Assistant
# Institution: Center for Community Partnerships, University of Virginia
# Date:        Summer 2026
# ==============================================================================

# ==============================================================================
# Advisories and File Structure 
# ==============================================================================

# Files in this script are managed locally and will need to be updated.
# This script assumes the following file structure and file names: 

cat("
DATA STRUCTURE

base_path/
├── data/
│   ├── dstr_lvl/
│   │   ├── all.csv
│   │   ├── disadvantaged.csv
│   │   ├── englishlearner.csv
│   │   ├── race.csv
│   ├── schl_lvl/
│   │   ├── all.csv
│   │   ├── disadvantaged.csv
│   │   ├── englishlearner.csv
│   │   ├── race.csv
│   ├── state_lvl/
│   │   ├── all.csv
│   │   ├── disadvantaged.csv
│   │   ├── englishlearner.csv
│   │   ├── race.csv
│   ├── exports/
")

# ==============================================================================
# Libraries and Inputs
# ==============================================================================

# Uncomment if installation needed:
#install.packages("readr") 
#install.packages("dplyr") 

# Inputs
library(dplyr)
library(readr)

# Global path variable (***UPDATE THIS***)
path <- "/Users/emilymcmahon/Downloads/CCP/data/"

# ==============================================================================
# Overall Data
# ==============================================================================
#=====================
# State Level
#=====================

# Read in data
data_all_state <- read_csv(file.path(path,"state_lvl/all.csv"))

# Create columns for Group, Entity, & School ID
data_all_state$Group <- "All Students"
data_all_state$Entity <- "Virginia"
data_all_state$School_ID <- NA

# Clean & structure data
data_all_state <- data_all_state %>%
  rename(
    Year = `School Year`,
  )

data_all_state$`Pass Rate` <- as.character(data_all_state$`Pass Rate`)
data_all_state$`Total Count` <- as.character(data_all_state$`Total Count`)


data_all_state <- data_all_state[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

#=====================
# District Level
#=====================

# Read in data
data_all_dstr <- read_csv(file.path(path,"dstr_lvl/all.csv"))

# Create columns for Group & School ID
data_all_dstr$Group <- "All Students"
data_all_dstr$School_ID <- NA

# Clean & structure data
data_all_dstr <- data_all_dstr %>%
  rename(
    Year = `School Year`,
    Entity = `Division Name`
  )

data_all_dstr$`Pass Rate` <- as.character(data_all_dstr$`Pass Rate`)
data_all_dstr$`Total Count` <- as.character(data_all_dstr$`Total Count`)

data_all_dstr <- data_all_dstr[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_all <- bind_rows(data_all_state, data_all_dstr)

#=====================
# School Level
#=====================

# Read in data
data_all_schl <- read_csv(file.path(path,"schl_lvl/all.csv"))

# Create column for Group
data_all_schl$Group <- "All Students"

# Clean & structure data
data_all_schl <- data_all_schl %>%
  rename(
    Year = `School Year`,
    Entity = `School Name`,
    School_ID = `School Number`
  )

data_all_schl$`Pass Rate` <- as.character(data_all_schl$`Pass Rate`)
data_all_schl$`Total Count` <- as.character(data_all_schl$`Total Count`)

data_all_schl <- data_all_schl[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_all <- bind_rows(data_all, data_all_schl)

# ==============================================================================
# Disadvantaged Data
# ==============================================================================
#=====================
# State Level
#=====================

# Read in file
data_disadvantaged_state <- read_csv(file.path(path,"state_lvl/disadvantaged.csv"))

# Rename column entries 
data_disadvantaged_state <- data_disadvantaged_state %>% 
  mutate(Disadvantaged = case_match(Disadvantaged,
                           "Y" ~ "Economically Disadvantaged",
                           "N"  ~ "Economically Advantaged",
                           .default = NA
  ))

# Create columns for Entity & School ID
data_disadvantaged_state$Entity <- "Virginia"
data_disadvantaged_state$School_ID <- NA


# Clean & structure data
data_disadvantaged_state <- data_disadvantaged_state %>%
  rename(
    Year = `School Year`,
    Group = Disadvantaged
  )

data_disadvantaged_state$`Pass Rate` <- as.character(data_disadvantaged_state$`Pass Rate`)
data_disadvantaged_state$`Total Count` <- as.character(data_disadvantaged_state$`Total Count`)

data_disadvantaged_state <- data_disadvantaged_state[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

#=====================
# District Level
#=====================

# Read in data
data_disadvantaged_dstr <- read_csv(file.path(path,"dstr_lvl/disadvantaged.csv"))

# Rename column entries
data_disadvantaged_dstr <- data_disadvantaged_dstr %>% 
  mutate(Disadvantaged = case_match(Disadvantaged,
                                    "Y" ~ "Economically Disadvantaged",
                                    "N"  ~ "Economically Advantaged",
                                    .default = NA
  ))

# Create column for School ID
data_disadvantaged_dstr$School_ID <- NA

# Clean & structure data
data_disadvantaged_dstr <- data_disadvantaged_dstr %>%
  rename(
    Year = `School Year`,
    Entity = `Division Name`,
    Group = Disadvantaged
  )

data_disadvantaged_dstr$`Pass Rate` <- as.character(data_disadvantaged_dstr$`Pass Rate`)
data_disadvantaged_dstr$`Total Count` <- as.character(data_disadvantaged_dstr$`Total Count`)

data_disadvantaged_dstr <- data_disadvantaged_dstr[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_disadvantaged <- bind_rows(data_disadvantaged_state, data_disadvantaged_dstr)

#=====================
# School Level
#=====================

# Read in data
data_disadvantaged_schl <- read_csv(file.path(path,"schl_lvl/disadvantaged.csv"))

# Rename column entries
data_disadvantaged_schl <- data_disadvantaged_schl %>% 
  mutate(Disadvantaged = case_match(Disadvantaged,
                                    "Y" ~ "Economically Disadvantaged",
                                    "N"  ~ "Economically Advantaged",
                                    .default = NA
  ))

# Clean & structure data
data_disadvantaged_schl <- data_disadvantaged_schl %>%
  rename(
    Year = `School Year`,
    Entity = `School Name`,
    Group = Disadvantaged,
    School_ID = `School Number`
  )

data_disadvantaged_schl$`Pass Rate` <- as.character(data_disadvantaged_schl$`Pass Rate`)
data_disadvantaged_schl$`Total Count` <- as.character(data_disadvantaged_schl$`Total Count`)

data_disadvantaged_schl <- data_disadvantaged_schl[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_disadvantaged <- bind_rows(data_disadvantaged, data_disadvantaged_schl)

# ==============================================================================
# English Learner Data
# ==============================================================================
#=====================
# State Level
#=====================

# Read in data
data_el_state <- read_csv(file.path(path,"state_lvl/englishlearner.csv"))

# Rename column entries 
data_el_state <- data_el_state %>% 
  mutate(`English Learners` = case_match(`English Learners`,
                                    "Y" ~ "English Learners",
                                    "N"  ~ "Non-English Learners",
                                    .default = NA
  ))

# Create columns for Entity & School ID
data_el_state$Entity <- "Virginia"
data_el_state$School_ID <- NA


# Clean & structure data
data_el_state <- data_el_state %>%
  rename(
    Year = `School Year`,
    Group = `English Learners`
  )

data_el_state$`Pass Rate` <- as.character(data_el_state$`Pass Rate`)
data_el_state$`Total Count` <- as.character(data_el_state$`Total Count`)

data_el_state <- data_el_state[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

#=====================
# District Level
#=====================

# Read in data
data_el_dstr <- read_csv(file.path(path,"dstr_lvl/englishlearner.csv"))

# Rename column entries
data_el_dstr <- data_el_dstr %>% 
  mutate(`English Learners` = case_match(`English Learners`,
                                         "Y" ~ "English Learners",
                                         "N"  ~ "Non-English Learners",
                                         .default = NA
  ))


# Create column for School ID
data_el_dstr$School_ID <- NA

# Clean & structure data
data_el_dstr <- data_el_dstr %>%
  rename(
    Year = `School Year`,
    Entity = `Division Name`,
    Group = `English Learners`
  )

data_el_dstr$`Pass Rate` <- as.character(data_el_dstr$`Pass Rate`)
data_el_dstr$`Total Count` <- as.character(data_el_dstr$`Total Count`)

data_el_dstr <- data_el_dstr[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_el <- bind_rows(data_el_state, data_el_dstr)

#=====================
# School Level
#=====================

# Read in data
data_el_schl <- read_csv(file.path(path,"schl_lvl/englishlearner.csv"))

# Rename column entries
data_el_schl <- data_el_schl %>% 
  mutate(`English Learners` = case_match(`English Learners`,
                                         "Y" ~ "English Learners",
                                         "N"  ~ "Non-English Learners",
                                         .default = NA
  ))

# Clean & structure data
data_el_schl <- data_el_schl %>%
  rename(
    Year = `School Year`,
    Entity = `School Name`,
    School_ID = `School Number`,
    Group = `English Learners`
  )

data_el_schl$`Pass Rate` <- as.character(data_el_schl$`Pass Rate`)
data_el_schl$`Total Count` <- as.character(data_el_schl$`Total Count`)

data_el_schl <- data_el_schl[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_el <- bind_rows(data_el, data_el_schl)

# ==============================================================================
# Race Data
# ==============================================================================
#=====================
# State Level
#=====================

# Read in data
data_race_state <- read_csv(file.path(path,"state_lvl/race.csv"))

# Create columns for Entity & School ID
data_race_state$Entity <- "Virginia"
data_race_state$School_ID <- NA

# Clean & structure data
data_race_state <- data_race_state %>%
  rename(
    Year = `School Year`,
    Group = Race
  )

data_race_state$`Pass Rate` <- as.character(data_race_state$`Pass Rate`)
data_race_state$`Total Count` <- as.character(data_race_state$`Total Count`)

data_race_state <- data_race_state[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

#=====================
# District Level
#=====================

# Read in data
data_race_dstr <- read_csv(file.path(path,"dstr_lvl/race.csv"))

# Create column for School ID
data_race_dstr$School_ID <- NA

# Clean & structure data
data_race_dstr <- data_race_dstr %>%
  rename(
    Year = `School Year`,
    Entity = `Division Name`,
    Group = `Race`
  )

data_race_dstr$`Pass Rate` <- as.character(data_race_dstr$`Pass Rate`)
data_race_dstr$`Total Count` <- as.character(data_race_dstr$`Total Count`)

data_race_dstr <- data_race_dstr[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_race <- bind_rows(data_race_state, data_race_dstr)

#=====================
# School Level
#=====================

# Read in data
data_race_schl <- read_csv(file.path(path,"schl_lvl/race.csv"))

# Clean & structure data
data_race_schl <- data_race_schl %>%
  rename(
    Year = `School Year`,
    Entity = `School Name`,
    School_ID = `School Number`,
    Group = `Race`
  )

data_race_schl$`Pass Rate` <- as.character(data_race_schl$`Pass Rate`)
data_race_schl$`Total Count` <- as.character(data_race_schl$`Total Count`)

data_race_schl <- data_race_schl[c("Year", "School_ID", "Entity", "Group", "Test","Pass Rate","Total Count")]

# Merge data subsections
data_race <- bind_rows(data_race, data_race_schl)

# Rename Race column entries
data_race <- data_race %>%
  mutate(Group = recode(Group,
                       "American Indian or Alaska Native" = "American Indian",
                       "Black, not of Hispanic origin" = "Black",
                       "Native Hawaiian or Pacific Islander" = "Native Hawaiian",
                       "Non-Hispanic, two or more races" = "Multiple Races",
                       "Unknown - Race/Ethnicity not provided" = "Unknown Race",
                       "White, not of Hispanic origin" = "White"
                       ))

# ==============================================================================
# Final Clean and Sort
# ==============================================================================

# Merge all data subsets
data_final <- bind_rows(data_all, data_disadvantaged, data_el, data_race)

# Sort
data_final <- data_final %>%
  arrange(Year, Entity)

# Pass rate and Total Count to numeric values
data_final$`Pass Rate` <- suppressWarnings(as.numeric(data_final$`Pass Rate`))
data_final$`Total Count` <- suppressWarnings(as.numeric(gsub(",", "", data_final$`Total Count`)))


# Identify School Name Changes (arranged chronologically in data subset)
schl_changes <- data_final %>%
  arrange(School_ID, Year) %>%
  group_by(School_ID) %>%
  summarise(
    Changes = paste(
      rle(Entity)$values,
      collapse = ", "
    ),
    .groups = "drop"
  )

# Hard code new names to reflect older entries
data_final <- data_final %>%
  mutate(
    Entity = case_when(
      School_ID == "890" ~ "Community Lab School (Formerly: Murray School, Murray High)",
      School_ID == "950" ~ "Journey Middle (Formerly: Jack Jouett Middle)",
      School_ID == "1051" ~ "Lakeside Middle (Formerly: Mortimer Y. Sutherland Middle)",
      TRUE ~ Entity
    )
  )

# ==============================================================================
# File Export
# ==============================================================================
write.csv(data_final, file.path(path,"exports/data.csv"), row.names=FALSE)
# ==============================================================================