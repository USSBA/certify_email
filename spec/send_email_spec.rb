require "spec_helper"
require 'vcr'

RSpec.describe CertifyEmail do
  describe "send an email" do
    context "with the correct parameters" do
      let(:email) { Faker::Internet.email }
      let(:message) { Faker::HeyArnold.quote }
      let(:template) { %w[basic_email].sample }
      let(:email_parameters) do
        {
          recipient: email,
          message: message,
          template: template
        }
      end

      let(:send_email) { CertifyEmail::Email.send_email(email_parameters) }

      # before do
      #   Excon.stub({method: :post}, status: 200)
      # end

      it "will return a 200 status" do
        expect(send_email[:status]).to eq(200)
      end
    end
  end

  describe "with incorrect parameters" do
    context 'with no paramters' do

      let(:no_parameters) { CertifyEmail::Email.send_email }

      it 'will return a 400 status' do
        expect(no_parameters[:status]).to eq(400)
      end
      it 'will return a no parameters error message' do
        expect(no_parameters[:body]).to match('Bad Request')
      end
    end
  end
end
