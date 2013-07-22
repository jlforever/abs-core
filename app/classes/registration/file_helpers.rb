require 's3_utils'

module Registration
  class FileHelpers
    
    S3_CONTENT_TYPE = 'application/pdf'
    S3_BUCKET_NAME = 'abs_reg'
    S3_REG_FORM_NAME = 'abs_registration_form.pdf'
    
    def self.upload_registration_form
      file = File.open(File.join(Rails.root, 'public', 
        'support_files', 'registration', 'abs_registration_form.pdf'), 'r')
      push_to_s3(file, S3_REG_FORM_NAME)
    end
    
    def self.url_for_registration_form
      S3Utils.url_for(S3_BUCKET_NAME, S3_REG_FORM_NAME).to_s
    end
    
    def self.push_to_s3(file, file_name)
      S3Utils.cp_to_s3(file, S3_CONTENT_TYPE, S3_BUCKET_NAME, file_name)
    end
    
  end
end