# 🎯 ChipScript 🐿️
*A Lightweight, Git-Backed Script Manager for Linux*

---

## 📌 What is ChipScript?
ChipScript is a **portable script manager** that allows you to:
- **Easily create and manage scripts** with simple commands.
- **Sync scripts across devices** using Git.
- **Keep track of installed scripts** with automatic versioning.
- **Load scripts automatically** in `.bashrc`.

---

## 🚀 How It Works
1️⃣ **Clone ChipScript**  
   ```bash
   git clone git@github.com:<your-username>/ChipScript.git ~/ChipScript
   ```

2️⃣ **Run the installer**  
   ```bash
   bash ~/ChipScript/install.sh
   ```

3️⃣ **Start using ChipScript**  
   ```bash
   chipi.create myscript  # Create a new script package
   chipi.code myscript    # Open it in VS Code
   chipi.commit "Added myscript"
   chipi.push             # Sync it to GitHub
   ```

4️⃣ **Sync on another PC**  
   ```bash
   chipi.pull  # Fetch latest scripts
   ```

---

## ⚡ Key Features
✅ **Quick Script Creation** → `chipi.create myscript`  
✅ **Easy Editing** → `chipi.code myscript` (opens in VS Code)  
✅ **Git Integration** → `chipi.commit "msg"`, `chipi.push`, `chipi.pull`  
✅ **Automatic Version Tracking** → `chipi.version`  
✅ **Silent Updates** → `chipi.sync silence`  

---

## 🔗 Git Commands (Preconfigured)
| Command          | Description                                      |
|-----------------|--------------------------------------------------|
| `chipi.git`      | Runs Git commands inside ChipScript directory  |
| `chipi.commit "msg"` | Commits changes with a message         |
| `chipi.push`     | Pushes committed changes                      |
| `chipi.pull`     | Pulls the latest updates                      |
| `chipi.sync`     | Pulls updates and updates the version number  |

---

## 📦 Versioning System
- **`X.0.0`** → Major changes (structure updates).  
- **`X.Y.0`** → Minor updates (features, bug fixes).  
- **`X.Y.Z`** → Number of installed scripts (`chipi.version`).  

```bash
ChipScript 1.1.30 🐿️  # Means 30 script packages are installed
```

---

## 📜 License
MIT License - Use, modify, and contribute freely!

---

🔥 **ChipScript: A lightweight script manager with Git integration.**  
🚀 **Clone, create, sync, and run your scripts effortlessly!**

> Sync Test
