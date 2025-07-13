from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to Instagram login page
    driver.get("https://www.instagram.com/accounts/login/")

    time.sleep(3)  # Wait for the page to load fully

    # Enter username
    driver.find_element(By.NAME, "username").send_keys("your_username")

    # Enter password
    driver.find_element(By.NAME, "password").send_keys("your_password")

    # Click login button
    driver.find_element(By.XPATH, "//button[@type='submit']").click()

    time.sleep(5)  # Wait to see result / handle any popups
finally:
    driver.quit()
