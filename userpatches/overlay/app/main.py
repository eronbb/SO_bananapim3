# Exemplo Tkinter: substitua pelo seu script. O arquivo precisa se chamar main.py
import tkinter as tk
import time

root = tk.Tk()
root.configure(bg="black")
root.attributes("-fullscreen", True)   # tela cheia

label = tk.Label(root, fg="white", bg="black", font=("DejaVu Sans", 60))
label.pack(expand=True)

def tick():
    label.config(text=time.strftime("%H:%M:%S"))
    root.after(500, tick)

tick()
root.mainloop()
