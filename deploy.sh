#!/bin/bash
export HOME=/root
apt-get update
apt-get install -y python3-pip python3-venv git

cd /home/ubuntu
git clone https://github.com/aashish951/hate-speech-detector.git
cd hate-speech-detector

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

nohup venv/bin/gunicorn -w 1 -b 0.0.0.0:5000 --timeout 120 HateSpeech:app > app.log 2>&1 &
