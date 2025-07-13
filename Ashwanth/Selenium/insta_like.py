from instagram_login import instagram_login
from selenium.webdriver.common.by import By
import time

# Replace with your actual Instagram credentials
username = "your_username"
password = "your_password"

driver = instagram_login(username, password)

if driver:
    try:
        # Go to Explore page
        driver.get("https://www.instagram.com/explore/")
        time.sleep(3)

        # Click the first post
        first_post = driver.find_element(By.XPATH, "(//div[contains(@class, '_aagw')])[1]")
        first_post.click()

        time.sleep(2)

        # Click the like button
        like_button = driver.find_element(By.XPATH, "//span[@aria-label='Like']")
        like_button.click()

        time.sleep(3)
    finally:
        driver.quit()
