#!/usr/bin/python3
import sys
import json
import struct
import subprocess
import os

LOG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "debug.log")


def log(msg):
    with open(LOG_FILE, "a") as f:
        f.write(msg + "\n")


def read_message():
    raw_length = sys.stdin.buffer.read(4)
    if len(raw_length) == 0:
        log("No input received, exiting")
        sys.exit(0)
    length = struct.unpack("@I", raw_length)[0]
    log(f"Reading message of length {length}")
    payload = sys.stdin.buffer.read(length).decode("utf-8")
    log(f"Received: {payload}")
    return json.loads(payload)


def send_message(obj):
    encoded = json.dumps(obj, separators=(",", ":")).encode("utf-8")
    header = struct.pack("@I", len(encoded))
    sys.stdout.buffer.write(header)
    sys.stdout.buffer.write(encoded)
    sys.stdout.buffer.flush()
    log(f"Sent: {json.dumps(obj)}")


def main():
    log("--- Native host started ---")
    try:
        msg = read_message()
        url = msg.get("url", "")
        browser_name = msg.get("browser", "")

        if not url or not browser_name:
            send_message({"status": "error", "message": "Missing url or browser"})
            return

        log(f"Opening {url} in {browser_name}")
        subprocess.Popen(["open", "-a", browser_name, url])
        send_message({"status": "ok"})
    except Exception as e:
        log(f"Error: {e}")
        send_message({"status": "error", "message": str(e)})


if __name__ == "__main__":
    main()
