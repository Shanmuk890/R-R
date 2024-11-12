# Load the plumber package
library(plumber)
library(googleAuthR)
library(googleCloudStorageR)
library(logger)
# Create the function that sums two numbers
# This function will be exposed as an API endpoint
# The numbers will be passed as query parameters
write_to_volume <- function(content) {
  # Mount path for the volume
  mount_path <- "/mnt/my-volume/sample.txt"
  # Open the file in append mode and write the content
  file_connection <- file(mount_path, open = "a")
  writeLines(content, file_connection)
  close(file_connection)
  return(paste("Written to", mount_path))
}
#* @get /sum
#* @param a First number
#* @param b Second number
#* @response 200 Returns the sum of two numbers
function(a, b) {
  # Convert input to numeric and sum them
  a <- as.numeric(a)
  b <- as.numeric(b)
  
  if (is.na(a) | is.na(b)) {
    return(list(error = "Both a and b must be valid numbers"))
  }
  
  # Sum the numbers
  result <- a + b
  return(list(sum = result))
}
