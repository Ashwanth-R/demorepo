from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Open product page and add to cart
    driver.get("https://www.example.com/product/123")
    driver.find_element(By.ID, "add-to-cart").click()

    time.sleep(1)  # Wait for cart update

    # Go to checkout
    driver.get("https://www.example.com/checkout")

    # Fill payment details (dummy example)
    driver.find_element(By.ID, "card-number").send_keys("4111111111111111")
    driver.find_element(By.ID, "expiry-date").send_keys("12/26")
    driver.find_element(By.ID, "cvv").send_keys("123")

    # Click pay
    driver.find_element(By.ID, "pay-button").click()

    time.sleep(3)  # Wait to see result
finally:
    driver.quit()
