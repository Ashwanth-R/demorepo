from selenium import webdriver
from selenium.webdriver.common.by import By
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to Twitter login page
    driver.get("https://twitter.com/login")

    time.sleep(3)  # Wait for page to load

    # Enter username
    driver.find_element(By.NAME, "text").send_keys("your_username")

    driver.find_element(By.XPATH, "//span[text()='Next']").click()

    time.sleep(2)  # Wait for next field to appear

    # Enter password
    driver.find_element(By.NAME, "password").send_keys("your_password")

    # Click login
    driver.find_element(By.XPATH, "//span[text()='Log in']").click()

    time.sleep(5)  # Wait to see login result
finally:
    driver.quit()
