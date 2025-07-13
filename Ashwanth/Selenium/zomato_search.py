from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Initialize Chrome browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.zomato.com/")  # Open Zomato
    time.sleep(3)  # Wait for page to load

    # Find location input box and enter city
    location_input = driver.find_element(By.XPATH, "//input[@placeholder='Search for restaurant, cuisine or a dish']")
    location_input.send_keys("Pizza")
    location_input.send_keys(Keys.RETURN)

    print("✅ Searched for: Pizza")
    time.sleep(5)  # Wait to see search results

finally:
    driver.quit()
