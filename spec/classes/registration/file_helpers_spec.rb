require 'spec_helper'
require 's3_utils'

describe Registration::FileHelpers do

  describe ".upload_registration_form" do
    it "calls push to s3 to upload the file" do
      described_class.should_receive(:push_to_s3).
        with(instance_of(File), described_class::S3_REG_FORM_NAME).and_return
      described_class.upload_registration_form
    end
  end

end