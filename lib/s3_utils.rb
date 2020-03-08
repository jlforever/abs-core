require 'aws-sdk'
require 'let'

module S3Utils
  def self.cp_to_s3(src_file, src_mime_type, dst_bucket_name, dst_object_name)
    with_bucket_and_object(dst_bucket_name, dst_object_name) do |_, dst_object|
      dst_object.write(:file => src_file, :content_type => src_mime_type)
    end
  end

  def self.data_to_s3(string, src_mime_type, dst_bucket_name, dst_object_name)
    with_bucket_and_object(dst_bucket_name, dst_object_name) do |_, dst_object|
      dst_object.write(string, :content_type => src_mime_type)
    end
  end

  def self.url_for(bucket_name, object_name)
    with_bucket_and_object(bucket_name, object_name) do |_, object|
      object.url_for(:read)
    end
  end
  
  def self.content_length(bucket_name, object_name)
    if metadata_hash = metadata(bucket_name, object_name)
      metadata_hash[:content_length]
    end
  end
  
  def self.last_modified(bucket_name, object_name)
    if metadata_hash = metadata(bucket_name, object_name)
      metadata_hash[:last_modified]
    end
  end
  
  def self.metadata(bucket_name, object_name)
    begin
      with_bucket_and_object(bucket_name, object_name) do |_, object|
        object.head
      end
    rescue AWS::S3::Errors::NoSuchKey => e
      Rails.logger.error "S3Utils: No Such Key with input Bucket: #{bucket_name} and Object: #{object_name}"
      nil
    end
  end
  private_class_method :metadata

  def self.config_keys
    {
      :access_key_id     => ENV['S3_ACCESS_KEY'],
      :secret_access_key => ENV['S3_ACCESS_KEY_SECRET']
    }
  end
  private_class_method :config_keys

  def self.scope_bucket_name(bucket_name)
    "#{bucket_name}"
  end
  private_class_method :scope_bucket_name

  def self.with_bucket_and_object(bucket_name, object_name)
    AWS::S3.new(config_keys).let do |s3|
      s3.buckets.create(scope_bucket_name(bucket_name)).let do |bucket|
        bucket.objects[object_name].let do |object|
          yield bucket, object
        end
      end
    end
  end
  private_class_method :with_bucket_and_object
end