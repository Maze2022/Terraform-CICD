terraform {
  backend "s3" {
    bucket = "mymazebucket8425"
    key    = "terraformstatefile"
    region = "us-west-2"
  }
}
