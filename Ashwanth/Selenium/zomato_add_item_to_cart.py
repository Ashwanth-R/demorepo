from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Start Chrome browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.zomato.com/")
    time.sleep(3)  # wait for page load

    # Search for a dish (e.g., 'Burger')
    search_input = driver.find_element(By.XPATH, "//input[@placeholder='Search for restaurant, cuisine or a dish']")
    search_input.send_keys("Burger")
    search_input.send_keys(Keys.RETURN)
    print("✅ Searched for 'Burger'")
    time.sleep(5)

    # Click on the first restaurant from search results
    restaurants = driver.find_elements(By.XPATH, "//a[contains(@href,'/restaurants/')]")
    if restaurants:
        restaurants[0].click()
        print("✅ Opened first restaurant")
    else:
        print("❌ No restaurant found")
        driver.quit()
        exit()

    time.sleep(5)

    # Click on the first 'Add' button to add an item to cart
    add_buttons = driver.find_elements(By.XPATH, "//div[contains(text(),'Add')]")
    if add_buttons:
        add_buttons[0].click()
        print("✅ Added first item to cart")
    else:
        print("❌ No 'Add' button found")

    time.sleep(5)  # Keep browser open for a while to see result

finally:
    driver.quit()
