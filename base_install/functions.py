def ask_input(prompt, default=""):
    user_input = input(f"{prompt} [{default}]: ").strip()
    return user_input if user_input else default
