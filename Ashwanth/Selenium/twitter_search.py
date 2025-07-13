from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    driver.get("https://twitter.com/explore")

    time.sleep(3)  # wait for page to load

    # Find search box and search for a hashtag
    search_box = driver.find_element(By.XPATH, "//input[@aria-label='Search query']")
    search_box.send_keys("#python")
    search_box.send_keys(Keys.RETURN)

    time.sleep(5)  # wait to see results
finally:
    driver.quit()
