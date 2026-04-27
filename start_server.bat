@echo off
cd /d "c:\Users\ACER\Documents\Tugas\uiux"
echo Starting HTTP server on port 8000...
echo Access at: http://localhost:8000
echo Press Ctrl+C to stop the server
python -m http.server 8000
pause