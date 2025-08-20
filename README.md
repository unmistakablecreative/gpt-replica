# 🧠 GPT Replica

Run a full GPT-style UI locally — no API keys, no OpenAI, no lock-in.  
This repo gives you everything you need to replicate ChatGPT using open-source models and a local interface powered by [Ollama](https://ollama.com) and [Gradio](https://gradio.app).

---

## 📦 Full Installation Instructions

This will work on **macOS or Linux** with a clean system.

### 1. Install Python (if not already installed)

On macOS:
```bash
brew install python
```

On Ubuntu/Debian:
```bash
sudo apt update && sudo apt install python3 python3-venv python3-pip
```

---

### 2. Install Ollama

Download from: https://ollama.com/download  
Or via Homebrew (macOS):
```bash
brew install ollama
```

Then start the Ollama server:
```bash
ollama serve &
```

---

### 3. Pull a model

For this setup, we’ll use **llama3** (free, open-weight):
```bash
ollama pull llama3
```

---

### 4. Clone this repo

```bash
git clone https://github.com/unmistakablecreative/gpt-replica.git
cd gpt-replica
```

---

### 5. Create a Python virtual environment

```bash
python3 -m venv gpt-oss-env
source gpt-oss-env/bin/activate
```

---

### 6. Install Python dependencies

```bash
pip install --upgrade pip
pip install gradio requests
```

---

### 7. Run the interface

```bash
python3 connect_open.py
```

It will open a browser window at:
```
http://localhost:7860
```

---

## 🛠️ Notes

- You can change the model in `connect_open.py` by editing `MODEL_NAME = "llama3"`
- Any Ollama-supported model works — `mistral`, `gemma`, `gpt-oss:20b`, etc.
- No API keys, no token tracking, no vendor dependencies
- Everything runs **fully locally**

---

## 📖 Want to Know Why This Matters?

Read the full teardown:  
👉 [Why Nobody Will Win the Model Wars](https://YOURBLOGURL)