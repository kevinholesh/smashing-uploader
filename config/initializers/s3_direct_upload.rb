S3DirectUpload.config do |c|
  c.access_key_id = ENV['S3_ACCESS_KEY_ID']
  c.secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
  c.bucket = ENV['FOG_DIRECTORY']
end