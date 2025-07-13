from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.pinterest.com")

    time.sleep(3)  # wait for page to load

    # Find search box and search for "home decor"
    search_box = driver.find_element(By.NAME, "searchBoxInput")
    search_box.send_keys("home decor")
    search_box.send_keys(Keys.RETURN)

    time.sleep(3)  # wait for results

    # Click the first pin
    first_pin = driver.find_element(By.XPATH, "(//div[@data-test-id='pin'])[1]")
    first_pin.click()

    time.sleep(5)  # view pin
finally:
    driver.quit()
