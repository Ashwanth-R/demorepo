from selenium import webdriver
from selenium.webdriver.common.by import By
import time

def login_to_site(username, password):
    driver = webdriver.Chrome()

    try:
        driver.get("https://www.example.com/login")

        time.sleep(2)  # wait for page to load

        driver.find_element(By.ID, "username").send_keys(username)
        driver.find_element(By.ID, "password").send_keys(password)
        driver.find_element(By.ID, "login-button").click()

        time.sleep(3)  # wait to see login result

        return driver  # return driver so next script can reuse
    except Exception as e:
        print("Login failed:", e)
        driver.quit()
        return None
