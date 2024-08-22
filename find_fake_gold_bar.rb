# gem install selenium-webdriver
require 'selenium-webdriver'

# Initialize the browser
driver = Selenium::WebDriver.for :chrome
driver.navigate.to 'https://sdetchallenge.fetch.com/'

def weigh_bars(driver, left_bars, right_bars)
  driver.find_element(:xpath, "//button[contains(text(),'Reset')]").click
  left_bars.each_with_index do |bar, index|
    driver.find_element(:id, "left_#{index}").send_keys(bar)
  end
  
  right_bars.each_with_index do |bar, index|
    driver.find_element(:id, "right_#{index}").send_keys(bar)
  end
end

def weigh(driver)
  driver.find_element(:id, 'weigh').click

  sleep 2
  result_list = driver.find_element(:css, '.game-info ol')

  # Get the latest weighing result from the last <li> element
  latest_result = result_list.find_elements(:tag_name, 'li').last.text

  if latest_result.nil? || latest_result.strip.empty?
    raise "Error: Weighing result is nil or empty."
  end

  latest_result
end

def find_fake_gold_bar(driver)
  weighing_list = []

  # First weighing: compare [0,1,2] vs [3,4,5]
  weigh_bars(driver, [0, 1, 2], [3, 4, 5])
  result = weigh(driver)
  puts "First Weighing Result :" +result
  weighing_list << result

  fake_bar_group = nil

  if result.include?("[0,1,2] < [3,4,5]")
    # Fake bar is in [0, 1, 2]
    fake_bar_group = [0, 1, 2]
  elsif result.include?("[0,1,2] > [3,4,5]")
    # Fake bar is in [3, 4, 5]
    fake_bar_group = [3, 4, 5]
  elsif result.include?("[0,1,2] = [3,4,5]")
    # Fake bar is in [6, 7, 8] (i.e., both sides were equal)
    fake_bar_group = [6, 7, 8]
  else
    raise "Error Group: Unexpected weighing result format - #{result}"
  end

  # Check if fake_bar_group is set before proceeding
  if fake_bar_group.nil?
    raise "Error Group: fake_bar_group not determined correctly."
  end

  # Second weighing: compare two bars in the identified group
  weigh_bars(driver, [fake_bar_group[0]], [fake_bar_group[1]])
  result = weigh(driver)
  puts "Second Weighing Result :"+result
  weighing_list << result

  fake_bar = nil

  if result.include?("<")
    fake_bar = fake_bar_group[0]
  elsif result.include?(">")
    fake_bar = fake_bar_group[1]
  elsif result.include?("=")
    fake_bar = fake_bar_group[2]
  end

  # Check if fake_bar is determined correctly
  if fake_bar.nil?
    raise "Error Bar: Fake bar could not be determined."
  end

  # Click on the button corresponding to the fake gold bar
  driver.find_element(id: "coin_#{fake_bar}").click

  # Capture and output the alert message
  alert = driver.switch_to.alert
  puts alert.text
  alert.accept

  # Output the list of weighings
  puts "Number of weighings: #{weighing_list.size}"
  puts "Weighing results: #{weighing_list.join(", ")}"
end

# Execute the fake gold bar detection
  find_fake_gold_bar(driver)

  # Close the browser
  driver.quit
