require 'action_view'
require 'active_support'

module ActiveRecord::Magic::Translate::Extend

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::SanitizeHelper

  ############
  ### Time ###
  ############
  def l(date, format=:long); I18n.l(date, :format => format) rescue date.to_s; end

  ################
  ### I18n key ###
  ################
  def i18n_key; @_18nkey ||= self.class.name.gsub('::','.').underscore; end
  def i18n_pkey; @_18npkey ||= i18n_key.rsubstr_to('.'); end
  def tkey(key); key.is_a?(Symbol) ? "#{i18n_key}.#{key}" : key; end

  #################
  ### Translate ###
  #################  
  def t(key, args={}); tt tkey(key), args; end
  def t!(key, args={}); tt! tkey(key), args; end
  def tp(key, args={}); tt "#{i18n_pkey}.#{key}", args; end
  def tr(key, args={}); tt "ricer3.#{key}", args; end
  def tt(key, args={}); rt i18t(key, args); end
  def tt!(key, args={}); rt i18t!(key, args); end
  
  def i18t!(key, args={}); I18n.t!(key, args); end
  def i18t(key, args={}) # Own I18n.t that rescues into key: arg.inspect
    begin
      I18n.t!(key, args)
    rescue I18n::MissingTranslationData => e
      bot.log.error("Missing translation: #{key}")
      i18ti(key, args)
    end
  end

  def i18ti(key, args={}) # Inspector version
    vars = args.length == 0 ? "" : ":#{args.to_json}"
    "#{key.to_s.rsubstr_from('.')||key}#{vars}"
  end

  def rt(response) # Default replace
    response # none
    # response.to_s.
      # gsub('$BOT$', (server.next_nickname rescue 'ricer')).
      # gsub('$CMD$', (plugin_trigger.to_s rescue '')).
      # gsub('$T$', (server.triggers[0] rescue ''))
  end
  
  ##############
  ### Helper ###
  ##############
  def in_english(&block)
    in_language('en', &block)
  end
  
  def in_language(locale, &block)
    old_locale = I18n.locale
    back = yield
    I18n.locale = old_locale
    back
  end

  #############
  ### Units ###
  #############
  def human_filesize(bytes)
    number_to_human_size(bytes)
  end
  
  def human_fraction(fraction, precision=1)
    number_with_precision(fraction, precision: precision)
  end
  
  def human_percent(fraction, precision=2)
    human_fraction(fraction*100, precision)+'%'
  end
  
  ################
  ### Duration ###
  ################
  def human_age(datetime)
    human_duration_between(datetime, Time.now)
  end

  def human_duration_between(a, b)
    human_duration((a.to_f - b.to_f).abs)
  end
  
  def human_duration(seconds, options={})
    ChronicDuration.output(seconds, chronic_options.merge(options))
  end
  
  def human_to_seconds(human, options={})
    ChronicDuration.parse(human, chronic_options.merge(options))
  end
  
  def chronic_options
    { format: :micro, units: 2 }
  end

  ############
  ### HTML ###
  ############
  def strip_html(html)
    ActionView::Base.full_sanitizer.sanitize(html)
  end

end
