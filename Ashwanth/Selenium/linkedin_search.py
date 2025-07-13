from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.linkedin.com")

    time.sleep(3)  # wait for page to load

    # Find search box and search for "Data Scientist"
    search_box = driver.find_element(By.XPATH, "//input[@placeholder='Search']")
    search_box.send_keys("Data Scientist")
    search_box.send_keys(Keys.RETURN)

    time.sleep(3)  # wait for search results

    # Click the first profile result
    first_result = driver.find_element(By.XPATH, "(//span[contains(@class,'entity-result__title-text')]/a)[1]")
    first_result.click()

    time.sleep(5)  # view profile
finally:
    driver.quit()
