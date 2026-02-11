docker plugin install --grant-all-permissions rexray/s3fs:latest \
S3FS_ACCESSKEY="XXXXXXXX" \
S3FS_SECRETKEY="XXXXXXXXXXXXXXXXXXXXXXXXXXX" \
S3FS_ENDPOINT=https://camelk.s3.eu-west-3.amazonaws.com \
S3FS_REGION=eu-west-3 \
S3FS_OPTIONS="allow_other,nonempty,use_path_request_style,url=https://camelk.s3.eu-west-3.amazonaws.com"



 docker volume create --driver rexray/s3fs \
  -o S3FS_BUCKET=camelk \
  bucket1
