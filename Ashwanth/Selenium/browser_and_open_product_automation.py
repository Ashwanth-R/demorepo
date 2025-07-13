from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to homepage
    driver.get("https://www.example.com")

    # Click on a category (replace with actual link or button)
    driver.find_element(By.LINK_TEXT, "Electronics").click()

    time.sleep(2)  # Wait for category page to load

    # Scroll down slightly to load more products
    driver.execute_script("window.scrollBy(0, 500);")
    time.sleep(1)

    # Click on the second product (change selector as needed)
    second_product = driver.find_element(By.XPATH, "(//div[@class='product-item']/a)[2]")
    second_product.click()

    time.sleep(3)  # Wait to view product details
finally:
    driver.quit()
