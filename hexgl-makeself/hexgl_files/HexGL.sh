#!/bin/bash

# Start the HTTP server in the background
python3 -m http.server &

# Wait for a moment to ensure the server starts
sleep 2

# Open the index.html file in the default system browser
xdg-open http://localhost:8000/index.html

