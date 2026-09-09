root@7d607105-frigate-fa-beta-rk:/# find / -type f -name "*.py" 2>/dev/null | xargs grep -l "/proc/device-tree/"
/opt/frigate/frigate/detectors/plugins/rknn.py
/opt/frigate/frigate/util/rknn_converter.py
/opt/conv2rknn.py
/config/ai-server/modules/ALPR/bin/linux/python38/venv/lib/python3.8/site-packages/cpuinfo/cpuinfo.py
/config/ai-server/modules/OCR/bin/linux/python38/venv/lib/python3.8/site-packages/cpuinfo/cpuinfo.py


find / -type f -name "*.py" 2>/dev/null | xargs grep -l "/proc/device-tree/" | xargs sed -i 's|/proc/device-tree/|/device-tree/|g'

find / -type f -name "*.py" 2>/dev/null | xargs grep  "/device-tree/" 
