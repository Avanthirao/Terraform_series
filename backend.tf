terraform {
   backend "s3" {
      bucket = "cust-bucket"
      key = "TERRAFORM-DYNAMODB.terraform.tfstate"
      region = "ap-southeast-1"
      #dynamodb_table = "terraform-state-lock-dynamo" # DynamoDB table used for state locking, note: first run day-4-statefile-s3
      #encrypt        = true  # Ensures the state is encrypted at rest in S3.
    }
  
}
