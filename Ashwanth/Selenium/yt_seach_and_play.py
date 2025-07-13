from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Open browser
driver = webdriver.Chrome()

try:
    # Go to YouTube homepage
    driver.get("https://www.youtube.com")

    time.sleep(2)  # Wait for page to load

    # Find the search box and type query
    search_box = driver.find_element(By.NAME, "search_query")
    search_box.send_keys("Python tutorial")
    search_box.send_keys(Keys.RETURN)

    time.sleep(3)  # Wait for search results

    # Click on the first video
    first_video = driver.find_element(By.XPATH, "(//a[@id='video-title'])[1]")
    first_video.click()

    time.sleep(5)  # Wait to start playing
finally:
    driver.quit()
