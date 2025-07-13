from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Open login page
    driver.get("https://www.example.com/login")

    # Enter username
    driver.find_element(By.ID, "username").send_keys("testuser")

    # Enter password
    driver.find_element(By.ID, "password").send_keys("password123")

    # Click login button
    driver.find_element(By.ID, "login-button").click()

    time.sleep(3)  # Wait to see result
finally:
    driver.quit()
