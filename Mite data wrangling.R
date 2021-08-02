#### Set up basic context ####

library(tidyverse)
library(dplyr) # technically, this should no be needed as dplyr is part of the tidyverse, but R has been weird lately..
library(tidyr) # technically, this should no be needed as dplyr is part of the tidyverse, but R has been weird lately..
library(janitor)

# Copy / load mite data files into the data_in directory before starting any of this!

# set current mite data export files as inputs
midlands <- "data_in/Midlands mite sample data up to strips in spring 2020.xlsx"
mite_data <- "data_in/Complete Mite Monitor GP.xlsx"
barries <- "data_in/Barries Honey Mite Monitor data collection.xlsx"
hantz <- "data_in/Varroa Monitoring_Results_Hantz Honey_AUT21.xlsx"


#### Step 1: load Midlands file, clean up some things, reshape / melt to make it fit the rest of the data #### 

load_midlands <- function(midlands)    {
  
  midlands_mites <- readxl::read_xlsx(midlands) %>% 
    
    # clean and autoformat column names, so they are standardised across files
    janitor::clean_names() %>% 
    
    # select only useful columns
    dplyr::select(apiary = site_details, sample_1, sample_2, sample_3, sample_4, sample_5, sample_6, sample_7, sample_8, sample_9, sample_10, date = date_of_sample) %>% 
    
    # reshape to fit with the mite data format
    pivot_longer(cols = 2:11, names_to = "hive", values_to = "mite_count") %>%
    
    # add beekeeper column to allow concatenation with other data
    dplyr::mutate(beekeeper = "Midlands",
                  treatment = NA,
                  moved_to = NA) %>% 
    
    # drop rows with no observations
    dplyr::filter(!is.na(mite_count)) %>% 
  
    # reorder columns so we can rowbind with mites data
    dplyr::select(beekeeper, apiary, date, hive, mite_count, treatment, moved_to)
  
}
 
midlands_mites <- load_midlands(midlands)


#### Step 2: load BeeSmart / Rae file, clean up some things #### 

load_mites <- function(mite_data)    {
  
  mites <- readxl::read_xlsx(mite_data, sheet = "Mite Counts") %>% 
    
    # clean and autoformat column names, so they are standardised across files
    janitor::clean_names() %>% 
    
    # drop the mite count / 100 bees column
    dplyr::select(!mite_count_100_bees) %>% 
    
    # convert mite counts to numeric
    dplyr::mutate(mite_count = as.numeric(mite_count))
  
}   
    
mites <- load_mites(mite_data)


#### Step 3: load Barries file, clean up some things #### 

load_barries <- function(barries) {
  
  # load input file
  barries_mites <- bind_rows(readxl::read_xlsx(barries, sheet = "Barries Honey - 0"), 
                            readxl::read_xlsx(barries, sheet = "Barries Honey - 1"),
                            readxl::read_xlsx(barries, sheet = "Barries Honey - 2")) %>% 
    
    # clean and autoformat column names, so they are standardised across files
    janitor::clean_names() %>% 
    
    # select relevant columns only
    dplyr::select(apiary = site, date, mite_count_hive_number_1, mite_count_hive_number_2, mite_count_hive_number_3) %>% 
    
    # reshape to fit with the mite data format
    pivot_longer(cols = 3:5, names_to = "hive", values_to = "mite_count") %>% 
    
    # add beekeeper column
    dplyr::mutate(beekeeper = "Barries Honey",
                  treatment = NA,
                  moved_to = NA)
  
  barries_mites <- barries_mites[,c("beekeeper", "apiary", "date", "hive", "mite_count", "treatment", "moved_to")]
  
}

barries_mites <- load_barries(barries)


#### Step 4: load Hantz Honey data, clean up and reshape ####

load_hantz <- function(hantz)    {

  hantz_mites <- readxl::read_xlsx(hantz) %>%

    # clean and autoformat column names, so they are standardised across files
    janitor::clean_names() %>%
    dplyr::mutate(longitude = as.numeric(sub(".*,", "", gps_co_ord_site)),
                  latitude = as.numeric(sub(",.*", "", gps_co_ord_site))) %>%
    
    # drop superfluous columns
    dplyr::select(!gps_co_ord_site) %>%

    # reshape to fit with the mite data format
    pivot_longer(cols = 6:15, names_to = "hive", values_to = "mite_count") %>%

    # add beekeeper column to allow concatenation with other data
    dplyr::mutate(beekeeper = "Hantz Honey",
                  treatment = "Bayvarol",
                  moved_to = NA) %>%
    
    # drop rows with no observations
    dplyr::filter(!is.na(mite_count)) %>%
    
    # Add Year + Month columns for later aggregation
    dplyr::mutate(month = format(date, "%m"),
                  year = format(date, "%Y")) %>% 

    # rename columns to match other mite data + reorder
    dplyr::select(beekeeper, apiary = area, date, date, mite_count, treatment, moved_to, month, year, latitude, longitude)

}

hantz_mites <- load_hantz(hantz)

#### Step 5: load apiaries + clean up some things #### 

load_apiaries <- function(mite_data) {
  apiaries <- readxl::read_xlsx(mite_data, sheet = "Apiaries") %>% 
    
    # clean and autoformat column names, so they are standardised across files
    janitor::clean_names() %>% 
    
    # drop (accidental) rows without any information
    dplyr::filter(!is.na(apiary)) %>% 
    
    # convert latitude and longitude to numeric
    dplyr::mutate(latitude = as.numeric(latitude),
                 longitude = as.numeric(longitude))

}

apiaries <- load_apiaries(mite_data)

load_apiaries_barries <- function(barries) {
  
  apiaries_barries <- readxl::read_xlsx(barries, sheet = "Apiary List") %>% 
    janitor::clean_names() %>% 
    dplyr::select(apiary = yard_name, latitude = lat, longitude = long) %>% 
    dplyr::mutate(beekeeper = "Barries Honey")
  
  apiaries_barries <- apiaries_barries[,c("beekeeper", "apiary", "latitude", "longitude")]
    
}

apiaries <- dplyr::bind_rows(apiaries, load_apiaries_barries(barries))


#### Step 6: merge all the different mite datasets and apiary data #### 

mites <- dplyr::bind_rows(mites, midlands_mites, barries_mites)%>% 
  
  # Add Year + Month columns for later aggregation
  dplyr::mutate(month = format(date, "%m"),
                year = format(date, "%Y"))

mites_location <- dplyr::left_join(mites, apiaries, by = c("beekeeper", "apiary")) %>% 
  
  dplyr::filter(!is.na(longitude)) %>% 
  dplyr::filter(!is.na(date)) %>% 
  
  dplyr::bind_rows(hantz_mites)

write.csv(mites_location, "mite_data_mite_monitor13July2021.csv")
