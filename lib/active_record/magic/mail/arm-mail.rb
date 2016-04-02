module ActiveRecord
  module Magic
    class Mail
      
      require "mail"
      
      def self.configure(arm_config, &block)
        @arm_config = arm_config
        conf = arm_config.get('mail', nil) || default_config
        yield(conf) if block_given?
        case conf[:method]
        when :smtp; ::Mail.defaults { delivery_method :smtp, conf[:smtp] }
        when :sendmail; ::Mail.defaults { delivery_method :sendmail, conf[:sendmail] }
        else raise ActiveRecord::Magic::InvalidConfig.new("invalid mail method: #{conf[:method]}")
        end
        self
      end
      
      def self.generic(to, subject, body)
        byebug
        if @arm_config.nil?
          raise ActiveRecord::Magic::MissingConfiguration.new("You have to call ActiveRecord::Magic::Mailer.configure in prior to use the mailer")
        end
        arm_log.info{"Sending mail to #{to}: #{subject}"}
        conf = @arm_config.mail
        mail = ::Mail.new
        mail.from = conf[:from]
        mail.to = to
        mail.reply_to = conf[:reply_to]
        mail.subject = subject
        mail.body = body
        arm_log.debug{mail.to_s}
        mail.deliver if conf[:enabled]
      end
      
      def self.exception(e)
        generic(@arm_config.mail[:staff], "[#{@arm_config.app_name}] Exception", exception_body(e))
      end
      
      private
      
      def self.default_config
        arm_log.info{"You have to configure mail settings in your configuration file."}
        @arm_config.mail = {
          enabled: true,
          method: :smtp,
          from: 'robot@example.com',
          staff: ['admin@example.com', 'staff@example.com'],
          reply_to: 'support@example.com',
          smtp: {
            address: "mailserver.example.com",
            port: 587,
            domain: "yourserver.example.net",
            user_name: "username",
            password: "password",
            authentication: "login,plain",
            enable_starttls_auto: true,
            openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
          },
          sendmail: {
            location: '/usr/bin/sendmail',
            arguments: '-i -t'
          },
        }
      end
      
      def self.exception_body(e, message)
        body  = "Hi there,\n"
        body += "\n"
        body += "An exception occured in #{@arm_config.app_name}.\n"
        body += "\n"
        body += "Exception:\n"
        body += "\n"
        body += "#{e.to_s}\n"
        body += "(#{e.class.name})\n"
        body += "\n"
        body += "Stacktrace:\n"
        body += "\n"
        body += e.backtrace.join("\n") + "\n"
        body += "\n"
      end

    end
  end
end
