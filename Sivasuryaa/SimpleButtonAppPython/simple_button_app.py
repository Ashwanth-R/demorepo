import tkinter as tk

class SimpleButtonApp:
    def __init__(self, root):
        self.count = 0
        self.label = tk.Label(root, text=f"Button clicked: {self.count} times", font=("Arial", 16))
        self.label.pack(pady=20)
        self.button = tk.Button(root, text="Click Me", command=self.increment, font=("Arial", 14), bg="blue", fg="white")
        self.button.pack(pady=10)

    def increment(self):
        self.count += 1
        self.label.config(text=f"Button clicked: {self.count} times")

if __name__ == "__main__":
    root = tk.Tk()
    root.title("Simple Button App")
    root.geometry("300x200")
    app = SimpleButtonApp(root)
    root.mainloop()
