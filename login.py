def login_system():
    """
    A simple login system that prompts for a username and password
    and checks them against hardcoded values.
    """
    correct_username = "admin"
    correct_password = "password"

    username = input("Enter username: ")
    password = input("Enter password: ")

    if username == correct_username and password == correct_password:
        print("Login successful! Welcome...")
    else:
        print("Invalid username or password. Please try again.!!!")

# Call the login system function to initiate the login process
login_system()
