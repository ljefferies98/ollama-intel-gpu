#!/bin/bash

# Start Ollama in the background.
echo "Starting Ollama server..."
cd /llm/ollama
./ollama serve &
# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5

# Check if the Ollama process is running.
if ! kill -0 $pid 2>/dev/null; then
    echo "❌ Ollama server failed to start. Exiting."
    exit 1
fi

echo "🔴 Retrieve Deepseek model..."
if ./ollama pull deepseek-r1:1.5b; then
    echo "🟢 Deepseek model successfully retrieved!"
else
    echo "❌ Failed to pull Deepseek 1.5b model. Exiting."
    kill $pid
    exit 1
fi

echo "🔴 Retrieve Deepseek model..."
if ./ollama pull deepseek-r1:32b; then
    echo "🟢 Deepseek model successfully retrieved!"
else
    echo "❌ Failed to pull Deepseek 32b model. Exiting."
    kill $pid
    exit 1
fi

echo "🔴 Retrieve Qwen2.5 model..."
if ./ollama pull qwen2.5:1.5b; then
    echo "🟢 Qwen2.5 model successfully retrieved!"
else
    echo "❌ Failed to pull Qwen2.5 model. Exiting."
    kill $pid
    exit 1
fi

# Wait for Ollama process to finish.
echo "Waiting for Ollama process to finish..."
wait $pid
exit_code=$?

echo "Ollama process exited with code $exit_code."
exit $exit_code
