from flask import Flask
import subprocess

#systemload from uptime command
sysCmd = "uptime | grep -o 'load.*'"
#regex to show available space in percentages
diskCmd = "df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }'"

app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return 'API with 2 endpoints, /system checks load,/disk checks diskspace'


@app.route('/system', methods=['GET'])
def get_system_stats():
    result = subprocess.check_output(sysCmd, shell=True)
    return result


@app.route('/disk', methods=['GET'])
def get_disk_space():
    result = subprocess.check_output(diskCmd, shell=True)
    return result


if __name__ == '__main__':
    app.run(debug=True)
