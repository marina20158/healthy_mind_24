# import csv.file 
library(readr)
data <- read.csv("data_patients/patients.csv") 

#remove column SUFFIX (10)
library(dplyr)
data <-data %>% select (-SUFFIX)

# rename all columns to small letters 
data <- data %>% rename_all(tolower)

# rename selected columns
data <- data %>% rename(first_name = first, last_name = last,
                        birth_date = birthdate, death_date = deathdate, 
                        birth_place = birthplace)

# remove numbers from names (clean names)
data$first_name <- gsub("[0-9]", "", data$first_name) 
data$last_name <- gsub("[0-9]", "", data$last_name)
data$maiden <- gsub("[0-9]", "", data$maiden)

# convert the birth_date column data to the "date" data type
data$birth_date <- as.Date(data$birth_date, format = "%Y-%m-%d")

# select Ladies and Gentlemen (60 years and older)
selected_patients <- subset(data, as.Date(birth_date) <= as.Date(Sys.Date() - 60 * 365))

# exclude deceased patients
eligible_patients <- subset(selected_patients, is.na(death_date) | death_date == "")

# honorable psychologists (from NIMH) 
psychologists <- data.frame(
  name = c("John Smith", "Jane Doe", "Michael Johnson", "Emily Williams"),
  email = c("john@example.com", "jane@example.com", "michael@example.com", "emily@example.com"),
  phone = c("123-456-7890", "987-654-3210", "555-123-4567", "444-555-6666")
)

# set a function to send excellent news to psychologists

send_email <- function(subject, recipient, greeting, body) {
  message <- paste(greeting, "\n\n", body)
  print(paste("Sending an email with the subject:", subject))
  print(paste("To the address:", recipient))
  print(paste("The content of the letter: ", message))
}

# the patients' distribution among honorable psychologists

patients <- list("11, 21, 22, 24, 29, 45",
                 "46, 48, 55, 56, 67",
                 "69, 74, 75, 77, 81, 86",
                 "87, 94, 102, 104, 108")

for (i in seq_along(psychologists$name)) {
  send_email("Healthy_Mind", psychologists$email[i], paste("Dear Dr.", psychologists$name[i]), paste("The list of your patients", patients[[i]]))
}

