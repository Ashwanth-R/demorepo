from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Open Facebook login page
    driver.get("https://www.facebook.com/login")

    time.sleep(3)  # Wait for the page to load

    # Enter email / phone number
    driver.find_element(By.ID, "email").send_keys("your_email@example.com")

    # Enter password
    driver.find_element(By.ID, "pass").send_keys("your_password")

    # Click login button
    driver.find_element(By.NAME, "login").click()

    time.sleep(5)  # Wait to see login result or handle popups
finally:
    driver.quit()
