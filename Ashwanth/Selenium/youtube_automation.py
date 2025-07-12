from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Set the path to your WebDriver (e.g., chromedriver)
driver_path = "/path/to/chromedriver" # Replace with your actual path

# Initialize the WebDriver
driver = webdriver.Chrome()  # Or Firefox, Edge, etc.

# Open YouTube
driver.get("https://www.youtube.com")

# Find the search bar and enter a search term
search_box = driver.find_element(By.NAME, "search_query")
search_box.send_keys("Selenium tutorial")
search_box.send_keys(Keys.RETURN)

# Wait for the search results to load
wait = WebDriverWait(driver, 10)
wait.until(EC.presence_of_element_located((By.ID, "results")))

# Click on the first video (example)
video_link = driver.find_element(By.XPATH, "//a[@id='video-title']") # Adjust the XPath if needed
video_link.click()

# Optionally, wait for the video to start playing
wait.until(EC.presence_of_element_located((By.CLASS_NAME, "ytp-play-button")))

# You can add more actions here, like playing the video, pausing, etc.

# Keep the browser open for a few seconds
import time
time.sleep(5)

# Close the browser
driver.quit()