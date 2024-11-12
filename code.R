# Load the plumber package
library(plumber)
library(googleAuthR)
library(googleCloudStorageR)
library(logger)
# Create the function that sums two numbers
# This function will be exposed as an API endpoint
# The numbers will be passed as query parameters
write_to_cloud_storage <- function(content) {
  # Define your Cloud Storage bucket and file path
  bucket_name <- "rlang"
  
  # Create a unique file name using a timestamp
  timestamp <- format(Sys.time(), "%Y-%m-%d_%H-%M-%S")
  file_path <- paste0("api_logs/sum_result_", timestamp, ".txt")
  
  # Convert content to raw vector (this is required for uploading)
  content_raw <- charToRaw(content)
  
  # Upload to Cloud Storage
  gcs_upload(content_raw, bucket = bucket_name, name = file_path, overwrite = TRUE)
  
  return(paste("Written to Cloud Storage bucket:", bucket_name, "file:", file_path))
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
