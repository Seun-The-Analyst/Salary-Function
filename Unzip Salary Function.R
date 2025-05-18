# Load necessary package
if (!require("utils")) install.packages("utils", dependencies = TRUE)

display_zip_data <- function(zip_path) {
  # Check if the file path is missing
  if (missing(zip_path))
    stop("Error: The file path for the zipped folder must be provided.")
  }
  #Check for empty string
  if(zip_path == "") {
    stop("Error: The file path cannot be an empty string.")
  }
  cat("File path provided:", zip_path, "\n")

  # Check if the file exists
  if (!file.exists(zip_path)) {
    stop(paste("Error: The file", zip_path, "does not exist."))
  }
  
  # Create a temporary directory to extract files
  temp_dir <- tempdir()
  
  # Try unzipping the file
  tryCatch({
    # Unzip the folder
    unzip(zip_path, exdir = temp_dir)
    
    # List extracted files
    extracted_files <- list.files(temp_dir, full.names = TRUE)
    
    # Check if any files were extracted
    if (length(extracted_files) == 0) {
      stop("Error: No files found in the zipped folder.")
    }
    
    # Display each file's content
    for (file in extracted_files) {
      cat("\n--- Displaying content of:", basename(file), "---\n")
      
      # Determine file extension
      file_ext <- tools::file_ext(file)
      
      # Display content based on file type
      if (file_ext == "csv") {
        # Display first 5 rows of CSV files
        data <- tryCatch(read.csv(file), error = function(e) NULL)
        if (!is.null(data)) {
          print(head(data))
        } else {
          cat("Error: Failed to read CSV file:", basename(file), "\n")
        }
      } else if (file_ext %in% c("txt", "log")) {
        # Display first 10 lines of text files
        tryCatch({
          content <- readLines(file, n = 10)
          cat(content, sep = "\n")
        }, error = function(e) {
          cat("Error: Unable to read file:", basename(file), "\n")
        })
      } else {
        cat("Skipped unsupported file type:", file_ext, "\n")
      }
    }
  }, error = function(e) {
    cat("Error occurred during processing:", e$message, "\n")
  })
}

# Example usage:
# Replace "path/to/your/file.zip" with the actual path to the zipped folder
# display_zip_data("path/to/your/file.zip")
