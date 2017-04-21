#------------------------------------------------------------------------------*
# Load data for analysis
#------------------------------------------------------------------------------*

#------------------------------------------------------------------------------*
# Setup environment ----
#------------------------------------------------------------------------------*

# Load used packages
library(package = "readxl")
library(package = "tidyverse")




#------------------------------------------------------------------------------*
# Read data ----
#------------------------------------------------------------------------------*

# read data rectangle from excel
lutzomyia <- read_excel(path = "data/LarissaDC_Sandflies_Communitymetrics.xlsx")

# build better variable names (bind forest fragmentation and traps)
var_names <- lutzomyia %>%
  names() %>%
  data_frame(name = .) %>%
  mutate(
    group = stats::filter(x = !grepl("X_", name), 1, "recursive")
  ) %>%
  group_by(group) %>%
  mutate(
    new_name = gsub(" |[^a-z]", "_", tolower(first(name)))
  ) %>%
  pull(new_name) %>%
  paste(tolower(slice(lutzomyia, 1)), sep = ":") %>%
  gsub("_:", ":", .) %>%
  ifelse(grepl("collection", .), "species", .)


# rename dataset
lutzomyia <- lutzomyia %>%
  set_names(var_names) %>%
  slice(-1)


# extract sex totals and gather to tidy structure
lutzomyia_sex <- lutzomyia %>%
  select(species, matches("sex")) %>%
  gather(key = sex, value = total_indivituals, -species) %>%
  mutate(sex = gsub("^.+:", "", sex))


# extract site collections and gather to tidy structure
lutzomyia <- lutzomyia %>%
  select(-matches("sex")) %>%
  gather(key = variables, value = count, -species) %>%
  mutate(count = as.integer(count)) %>%
  separate(variables, into = c("site", "trap"), sep = ":")




#------------------------------------------------------------------------------*
# clean up ----
#------------------------------------------------------------------------------*

rm(var_names)


# End of script
