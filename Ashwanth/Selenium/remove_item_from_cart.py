from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to homepage
    driver.get("https://www.example.com")

    # Click on the cart icon or link
    driver.find_element(By.ID, "cart-link").click()

    time.sleep(2)  # Wait for cart page to load

    # Click the remove button for the first item in cart
    driver.find_element(By.XPATH, "(//button[contains(@class, 'remove')])[1]").click()

    time.sleep(2)  # Wait to see effect
finally:
    driver.quit()
