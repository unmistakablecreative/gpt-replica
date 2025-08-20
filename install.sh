#!/bin/bash

set -e

echo "🧠 Installing GPT-OSS Replica..."
echo "This script will set up a fully local, token-free chat UI using Ollama and Gradio."

# 1. Ensure Python is installed
if ! command -v python3 &>/dev/null; then
  echo "❌ Python3 not found. Please install Python 3.8+ before running this script."
  exit 1
fi

# 2. Create virtual environment (optional but clean)
python3 -m venv gpt-oss-env
source gpt-oss-env/bin/activate

# 3. Upgrade pip and install required packages
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install gradio requests

# 4. Install Ollama (if missing)
if ! command -v ollama &>/dev/null; then
  echo "📥 Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
fi

# 5. Set model name
MODEL_NAME="llama3"

# 6. Write connect_open.py
echo "🛠️ Generating connect_open.py..."
cat <<EOF > connect_open.py
import gradio as gr
import requests

OLLAMA_API = "http://localhost:11434/api/chat"
MODEL_NAME = "$MODEL_NAME"

chat_history = []

def chat(user_input, history):
    if not user_input.strip():
        return history, ""

    chat_history.append({"role": "user", "content": user_input})

    try:
        response = requests.post(OLLAMA_API, json={
            "model": MODEL_NAME,
            "messages": chat_history,
            "stream": False
        }, timeout=60)

        data = response.json()
        content = data.get("message", {}).get("content", "") if isinstance(data.get("message"), dict) else data.get("response", "")
        chat_history.append({"role": "assistant", "content": content})

        formatted = []
        for i in range(0, len(chat_history), 2):
            user_msg = chat_history[i]["content"]
            assistant_msg = chat_history[i+1]["content"] if i+1 < len(chat_history) else ""
            formatted.append((user_msg, assistant_msg))

        return formatted, ""

    except Exception as e:
        return history + [(user_input, f"❌ Error: {str(e)}")], ""

def reset():
    global chat_history
    chat_history = []
    return [], ""

with gr.Blocks(theme=gr.themes.Soft(primary_hue="blue")) as demo:
    gr.Markdown("""
        <style>
            .gradio-container {max-width: 750px; margin: auto;}
            textarea {font-size: 16px;}
            button {font-size: 15px;}
        </style>
        <div style='text-align: center; padding-top: 1em;'>
            <h1>🧠 GPT-OSS Replica</h1>
            <p style='font-size: 0.95em; color: gray;'>Running locally with <code>llama3</code> via <a href='https://ollama.com' target='_blank'>Ollama</a>. No keys. No cloud. No limits.</p>
        </div>
    """)

    chatbot = gr.Chatbot(
        label=None,
        height=480,
        show_copy_button=True,
        bubble_full_width=False
    )

    with gr.Row():
        with gr.Column(scale=8):
            msg = gr.Textbox(placeholder="Send a message...", show_label=False, lines=1, autofocus=True)
        with gr.Column(scale=1, min_width=80):
            send_btn = gr.Button("📤")
        with gr.Column(scale=1, min_width=80):
            clear_btn = gr.Button("🧹")

    msg.submit(chat, [msg, chatbot], [chatbot, msg])
    send_btn.click(chat, [msg, chatbot], [chatbot, msg])
    clear_btn.click(reset, outputs=[chatbot, msg])

demo.launch(server_name="0.0.0.0", server_port=7860)
EOF

# 7. Start Ollama server in background if not running
if ! pgrep -f "ollama" > /dev/null; then
  echo "🚀 Starting Ollama in background..."
  ollama serve &
  sleep 5
fi

# 8. Launch app
echo "🌐 Starting GPT-OSS Replica..."
python3 connect_open.py &

# 9. Open in browser
sleep 2
open "http://localhost:7860" || xdg-open "http://localhost:7860"

echo "✅ Done. GPT-OSS is running at http://localhost:7860"