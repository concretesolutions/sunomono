require 'appium_lib'

class BaseScreen
   def self.identificator(element_name, &block)
     define_method(element_name.to_s, *block)
   end

   class << self
     alias_method :value, :identificator
     alias_method :action, :identificator
     alias_method :trait, :identificator
   end

  def method_missing(method, *args)
    if method.to_s.start_with?('touch_')
       wait_element_for_touch public_send(method.to_s.sub('touch_', ''))

    elsif method.to_s.start_with?('enter_')
      enter args[0], public_send(method.to_s.sub('enter_', ''))

    elsif method.to_s.end_with?('_displayed?')
      element_displayed? public_send(method.to_s.sub('_displayed?', ''))
    else
     super
   end
  end

  # This method has been necessary, because the method_missing has overriding
  def respond_to_missing?
    true
  end

  def check_trait(timeout = 10)
     raise ElementNotFoundError,
        "#{trait} not found" unless
        wait_true(timeout) { find_element(:id, trait).displayed? }
  end

  def enter(text, element)
    wait = Selenium::WebDriver::Wait.new timeout: 30
    begin
      wait.until { find_element(:id, element).send_keys text }
    rescue Selenium::WebDriver::Error::TimeOutError => e
      raise "Problem on send keys to element #{element} \n Error: #{e.message}"
    end
  end

  def element_displayed?(element)
    wait = Selenium::WebDriver::Wait.new timeout: 30
    begin
      wait.until { find_element(:id, element).displayed? }
    rescue Selenium::WebDriver::Error::TimeOutError => e
      raise "Element #{element} not visible \n Error: #{e.message}"
    end
  end

   def wait_element_for_touch(element)
	 wait = Selenium::WebDriver::Wait.new timeout: 30
	 begin
       wait.until { find_element(:id, element).click }
     rescue Selenium::WebDriver::Error::TimeOutError => e
       raise "Problem on touch the element #{element} \n Error: #{e.message}"
     end
   end
end