from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Replace with real credentials
username = "testuser"
password = "testpass"

driver = webdriver.Chrome()

if driver:
    try:
        # Find the search box and search for "laptop"
        search_box = driver.find_element(By.ID, "search-input")
        search_box.send_keys("laptop")
        search_box.send_keys(Keys.RETURN)

        time.sleep(2)

        # Click on the first product
        driver.find_element(By.CSS_SELECTOR, ".product-item a").click()

        time.sleep(3)  # wait to view product details
    finally:
        driver.quit()
