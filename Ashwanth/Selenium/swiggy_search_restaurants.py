from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Start the Chrome browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.swiggy.com/")
    time.sleep(3)  # wait for page to load

    # Find the location input box
    location_input = driver.find_element(By.ID, "location")
    location_input.clear()
    location_input.send_keys("Chennai")
    time.sleep(1)

    # Submit the location (press Enter)
    location_input.send_keys(Keys.RETURN)

    print("✅ Searched for location: Chennai")
    time.sleep(5)  # wait to see results

finally:
    driver.quit()
