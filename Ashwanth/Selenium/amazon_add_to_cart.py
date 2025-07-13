from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Initialize browser
driver = webdriver.Chrome()

try:
    driver.get("https://www.amazon.in/")
    time.sleep(3)

    # Search for a product
    search_box = driver.find_element(By.ID, "twotabsearchtextbox")
    search_box.send_keys("laptop bag")
    search_box.send_keys(Keys.RETURN)
    print("✅ Searched for 'laptop bag'")
    time.sleep(3)

    # Click on the first product link
    first_product = driver.find_elements(By.CSS_SELECTOR, "div[data-component-type='s-search-result'] h2 a")
    if first_product:
        first_product[0].click()
        print("✅ Clicked first product")
    else:
        print("❌ No products found")
        driver.quit()
        exit()

    time.sleep(3)

    # Switch to new tab if opened
    driver.switch_to.window(driver.window_handles[-1])

    # Click 'Add to Cart' button
    add_to_cart_btn = driver.find_elements(By.ID, "add-to-cart-button")
    if add_to_cart_btn:
        add_to_cart_btn[0].click()
        print("✅ Added to cart")
    else:
        print("❌ 'Add to Cart' button not found")

    time.sleep(5)  # Wait to see the result

finally:
    driver.quit()
