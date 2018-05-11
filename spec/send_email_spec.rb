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

      #VCR.use_cassette 'send_email' do

        let(:send_email) { CertifyEmail::Email.send(email_parameters) }

        before do
           #Excon.stub({method: :post}, status: 200)
        end
      
        it "will return a 200 status" do
          expect(send_email[:status]).to eq(200)
        end

        # it "will have correct url" do
        #   expect(send_email[]).to eq(message)
        # end
        # connection = Excon.new 'http://localhost:3008/email_api/send_email', connect_timeout: '360'
        # response = connection.request method: :post,
        #                             path: 'email_api/send_email',
        #                             body: 'body',
        #                             headers:  { "Content-Type" => "application/json" } 
      #end

    end
  end

  describe "with incorrect parameters" do
    context 'with no parameters' do
      let(:no_parameters) { CertifyEmail::Email.send }

      it 'will return a 400 status' do
        expect(no_parameters[:status]).to eq(400)
      end
      it 'will return a no parameters error message' do
        expect(no_parameters[:body]).to match('Bad Request')
      end
    end
    context 'with no valid paramters' do
      let(:bad_parameters) do
        {
          foo: "bar"
        }
      end
      let(:invalid_email) { CertifyEmail::Email.send(bad_parameters) }

      it 'will return a 400 status' do
        expect(invalid_email[:status]).to eq(422)
      end
      it 'will return a no parameters error message' do
        expect(invalid_email[:body]).to match('Unprocessable Entity')
      end
    end
  end
end