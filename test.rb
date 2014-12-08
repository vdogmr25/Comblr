require "selenium-webdriver"

puts "Enter user email: "
email = gets.chomp
puts "Enter password: "
pass = gets.chomp

driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10)

driver.navigate.to "https://www.tumblr.com"

element = driver.find_element(:link, "Log in")
element.click

sleep 2

wait.until { driver.find_element(:id, "signup_email") }
element = driver.find_element(:id, "signup_email")
element.send_keys(email)
element = driver.find_element(:id, "signup_password")
element.send_keys(pass)
element = driver.find_element(:class, "login_btn")
element.click

wait.until { driver.find_element(:id, "new_post_label_text") }
driver.find_element(:id, "new_post_label_text").click

sleep 10

driver.switch_to.frame("post_two_ifr")
wait.until { driver.find_element(:css, "#tinymce") }
driver.find_element(:css, "#tinymce").send_keys("test")

driver.switch_to.default_content
driver.find_element(:css, "#create_post > div.chrome.blue.options").click

driver.find_element(:css, "#post_options > div > div > ul > li.queue > div").click

driver.find_element(:css, "#create_post > button").click

sleep 5

driver.quit