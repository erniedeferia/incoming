require 'postmark_mitt'

module Incoming
  module Strategies
    class Postmark
      include Incoming::Strategy

      def initialize(request)
        email = ::Postmark::Mitt.new(request.body.read)

        @attachments = email.attachments

        @message = Mail.new do
          headers email.headers
          from email.from
          to email.to
          reply_to email.reply_to
          subject email.subject

          body email.text_body

          html_part do
            content_type 'text/html; charset=UTF-8'
            body email.html_body
          end if email.html_body

          # TODO: File Attachments
          # email.attachments.each { |a| add_file :filename => a.file_name, :content => a.read }
        end
      end
    end
  end
end