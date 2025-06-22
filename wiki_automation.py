from selenium import webdriver
from selenium.webdriver.common.by import By
import time

driver = webdriver.Chrome()
driver.get("https://www.wikipedia.org/")

try:
    search_box = driver.find_element(By.NAME, "search")
    search_box.send_keys("Selenium Software")
    search_box.submit()
    time.sleep(2) # Let the results load

except Exception as e:
    print(f"An error occurred: {e}")
finally:
    driver.quit()
