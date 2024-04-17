require 'watir'
require 'selenium-webdriver'
require 'eyes_selenium'
require 'logger'

def new_eyes
  eyes = Applitools::Selenium::Eyes.new
  #eyes.server_url = 'https://massmutualeyesapi.applitools.com'
  eyes.force_full_page_screenshot = true
  eyes.stitch_mode = :CSS
  eyes.hide_scrollbars = true
  eyes.save_new_tests = false
  eyes.send_dom = true
  eyes.ignore_caret = true
  eyes.match_timeout = 0
  eyes.save_new_tests = false

  time = Time.now.getutc + Time.zone_offset('EST')
  batch = Applitools::BatchInfo.new(name="Debug_Batch: #{(time).strftime('%m.%d.%y')}")
  batch.id = "#{(time).strftime('%m.%d.%y')}"

  eyes.batch = batch
  eyes.branch_name = 'DEV'
  eyes.add_property('Environment', 'Dev')
  eyes.add_property('Feature', 'VQA Issue Debug')
  eyes.log_handler = Logger.new(STDOUT)
  eyes
end

def debug_test(url, test_name, baseline_name)
  browser = Watir::Browser.new :chrome
  browser.goto url
  sleep 5 # let the page load fully
  target = Applitools::Selenium::Target.window.fully.match_level(:strict)
  viewport = {width: '900', height: '500'}
  eyes = new_eyes
  eyes.open(app_name: 'Debug', test_name: test_name, driver: browser.driver, viewport_size: viewport)
  eyes.check(baseline_name, target)
  browser.close
  puts eyes.close(false) # print results
end

url1 = 'https://www.massmutual.com/protecting-your-information'
test1_name = 'test 1 will always complete'
baseline1_name = 'test 1 page'

debug_test(url1, test1_name, baseline1_name)

url2 = 'https://www.massmutual.com/contact-us'
test2_name = 'test 2 will always fail to open eyes'
baseline2_name = 'test 2 page'

debug_test(url2, test2_name, baseline2_name)
