from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Start browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.zomato.com/")
    time.sleep(3)  # wait to load

    # Search for a restaurant or item (simplest demo)
    search_input = driver.find_element(By.XPATH, "//input[@placeholder='Search for restaurant, cuisine or a dish']")
    search_input.send_keys("Pizza")
    search_input.send_keys(Keys.RETURN)
    print("✅ Searched for Pizza")
    time.sleep(5)

    # Click on the first restaurant in search results
    restaurants = driver.find_elements(By.XPATH, "//a[contains(@href,'/restaurants/')]")
    if restaurants:
        restaurants[0].click()
        print("✅ Clicked first restaurant")
    else:
        print("❌ No restaurant found")
        driver.quit()
        exit()

    time.sleep(5)

    # Click on the first "Add" button to add an item to cart
    add_buttons = driver.find_elements(By.XPATH, "//div[contains(text(),'Add')]")
    if add_buttons:
        add_buttons[0].click()
        print("✅ Added first item to cart")
    else:
        print("❌ No 'Add' button found")

    time.sleep(3)

    # Go to cart / payment page (Zomato usually shows a side cart)
    # We will try clicking cart icon if available
    cart_icon = driver.find_elements(By.XPATH, "//a[contains(@href,'/cart')]")
    if cart_icon:
        cart_icon[0].click()
        print("✅ Opened cart/payment page")
    else:
        print("⚠️ Couldn’t find cart icon; you might see side cart open automatically")

    time.sleep(5)  # View payment/cart page

finally:
    driver.quit()
