from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to home page
    driver.get("https://www.example.com")

    # Find the search box and enter query
    search_box = driver.find_element(By.ID, "search-input")
    search_box.send_keys("laptop")
    search_box.send_keys(Keys.RETURN)

    time.sleep(2)  # Wait for search results

    # Click on the first product in the results
    first_product = driver.find_element(By.CSS_SELECTOR, ".product-list .product-item a")
    first_product.click()

    time.sleep(3)  # Wait to view product details
finally:
    driver.quit()
