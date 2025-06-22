from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time

# Initialize the Chrome webdriver
driver = webdriver.Chrome()

# Navigate to Google
driver.get("https://www.google.com")

# Find the search box element (by name)
search_box = driver.find_element(By.NAME, "q")

# Enter the search term "Selenium in search bar"
search_box.send_keys("Selenium")
time.sleep(2)

# Press Enter to perform the search
search_box.send_keys(Keys.RETURN)

# Add a small delay to see the results (optional)
time.sleep(2)

# Close the browser
driver.quit()
