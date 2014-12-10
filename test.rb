require "selenium-webdriver"

# Ask to add to the queue
puts "Is this to added to the queue Y/N?"
queue = gets.chomp
if queue.downcase.eql?('y')
	puts "Adding your post to the queue."
else
	puts "Posting immediately."
end

# Input post
# Stops when a new line is entered with 'end entry'
puts "Enter text (to end entry, enter a line with 'end entry'): "
line = gets.chomp
text = ''
while not line.downcase.eql?('end entry')
	text += line
	line = gets.chomp
	if not line.downcase.eql?('end entry')
		text += "\n"
	end
end

# Authentication
puts "Enter user email: "
email = gets.chomp
puts "Enter password: "
pass = gets.chomp
puts "Do you use 2-factor Authentication Y/N?"
auth = gets.chomp
if auth.downcase.eql?('y')
	puts "Input your auth code: "
	auth = gets.chomp
end

# Start WebDriver
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(:timeout => 10)

# Go to tumblr and click on Log In
driver.navigate.to "https://www.tumblr.com"
driver.find_element(:link, "Log in").click

# Wait for log in page to load then input log in information
wait.until { driver.title.downcase.start_with? "log in" }
driver.find_element(:id, "signup_email").send_keys(email)
driver.find_element(:id, "signup_password").send_keys(pass)
driver.find_element(:class, "login_btn").click

# If using 2 factor auth, wait for 2 factor auth page to load, then input it.
if not auth.downcase.eql?('n')
	wait.until { driver.find_element(:id, "tfa_response_field") }
	driver.find_element(:id, "tfa_response_field").send_keys(auth)
	driver.find_element(:class, "login_btn").click
end

# Click on Text Post
wait.until { driver.find_element(:id, "new_post_label_text") }
driver.find_element(:id, "new_post_label_text").click

# Wait for test pane to load
wait.until { driver.find_element(:id, "post_two_ifr") }

# Switch to text pane iframe and input text
driver.switch_to.frame("post_two_ifr")
wait.until { driver.find_element(:css, "#tinymce") }
driver.find_element(:css, "#tinymce").send_keys(text)

# Switch out of the iframe
driver.switch_to.default_content

# Set to queue
if queue.downcase.eql?('y')
	driver.find_element(:css, "#create_post > div.chrome.blue.options").click
	driver.find_element(:css, "#post_options > div > div > ul > li.queue > div").click
end

# Click post
driver.find_element(:css, "#create_post > button").click

# Wait for post to occur then exit
sleep 5
driver.quit
