require 's3_utils'

module Registration
  class FileHelpers
    
    S3_CONTENT_TYPE = 'application/pdf'
    S3_BUCKET_NAME = 'abs_reg'
    S3_REG_FORM_NAME = 'abs_registration_form.pdf'
    S3_FREE_REG_FORM_NAME = 'abs_free_class_registration_form.pdf'
    
    def self.upload_registration_form
      file = File.open(File.join(Rails.root, 'public', 
        'support_files', 'registration', 'abs_registration_form.pdf'), 'r')
      push_to_s3(file, S3_REG_FORM_NAME)
    end
    
    def self.url_for_registration_form
      S3Utils.url_for(S3_BUCKET_NAME, S3_REG_FORM_NAME).to_s
    end
    
    def self.upload_free_class_registration_form
      file = File.open(File.join(Rails.root, 'public', 
        'support_files', 'registration', 'abs_free_class_registration_form.pdf'), 'r')
      push_to_s3(file, S3_FREE_REG_FORM_NAME)
    end
    
    def self.url_for_free_class_registration_form
      S3Utils.url_for(S3_BUCKET_NAME, S3_FREE_REG_FORM_NAME).to_s
    end
    
    def self.push_to_s3(file, file_name)
      S3Utils.cp_to_s3(file, S3_CONTENT_TYPE, S3_BUCKET_NAME, file_name)
    end
    
    def self.parse_reg_page_headers
      text = File.read(File.join(Rails.root, 'public', 'support_files', 'registration', 'reg_page_intro_text.txt'))
      lines = text.split(/\n/)
      puts lines
      { "header" => lines[0..-3], "date_time" => lines[-2..-1] }
    end
    
  end
end