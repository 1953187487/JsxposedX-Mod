#!/usr/bin/env python3
import json, os, time, uuid, hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

DATA = "/srv/data"
ACCOUNTS = os.path.join(DATA, "accounts.json")
SESSIONS = os.path.join(DATA, "sessions.json")
WWW = os.path.join(DATA, "www")

def load(p, default):
    try:
        with open(p) as f:
            return json.load(f)
    except Exception:
        return default

def save(p, obj):
    tmp = p + ".tmp"
    with open(tmp, "w") as f:
        json.dump(obj, f, ensure_ascii=False, indent=2)
    os.replace(tmp, p)

def refresh_online():
    sessions = load(SESSIONS, {})
    accounts = load(ACCOUNTS, [])
    now = time.time()
    for a in accounts:
        seen = 0
        for s in sessions.values():
            if s.get("username") == a.get("username"):
                seen = max(seen, s.get("lastSeen", 0))
        a["online"] = (now - seen) < 60 if seen else False
        if seen:
            a["lastSeen"] = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(seen))
    save(ACCOUNTS, accounts)

class Handler(BaseHTTPRequestHandler):
    def _json(self, code, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _body(self):
        n = int(self.headers.get("Content-Length") or 0)
        try:
            return json.loads(self.rfile.read(n) or b"{}")
        except Exception:
            return {}

    def do_OPTIONS(self):
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.end_headers()

    def do_GET(self):
        if self.path.startswith("/api/accounts"):
            refresh_online()
            accounts = load(ACCOUNTS, [])
            self._json(200, {"ok": True, "accounts": [
                {"username": a.get("username"), "online": a.get("online", False)}
                for a in accounts]})
        elif self.path.startswith("/api/ping"):
            self._json(200, {"ok": True, "service": "jsxposedx-mod", "time": int(time.time())})
        else:
            self.serve_static()

    def serve_static(self):
        path = self.path.split("?")[0]
        if path == "/":
            path = "/index.html"
        full = os.path.normpath(os.path.join(WWW, path.lstrip("/")))
        if not full.startswith(WWW) or not os.path.isfile(full):
            self._json(404, {"ok": False, "error": "not found"})
            return
        ctype = "application/octet-stream"
        ext = os.path.splitext(full)[1].lower()
        types = {".html": "text/html", ".js": "application/javascript", ".css": "text/css",
                 ".json": "application/json", ".png": "image/png", ".jpg": "image/jpeg",
                 ".apk": "application/vnd.android.package-archive", ".zip": "application/zip"}
        if ext in types:
            ctype = types[ext]
        with open(full, "rb") as f:
            body = f.read()
        self.send_response(200)
        self.send_header("Content-Type", ctype)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path.startswith("/api/register"):
            d = self._body()
            u, p = d.get("username", "").strip(), d.get("password", "")
            if not u or not p:
                return self._json(400, {"ok": False, "error": "用户名或密码为空"})
            accounts = load(ACCOUNTS, [])
            if any(a.get("username") == u for a in accounts):
                return self._json(409, {"ok": False, "error": "用户名已存在"})
            accounts.append({
                "username": u,
                "password": hashlib.sha256(p.encode()).hexdigest(),
                "registeredAt": time.strftime("%Y-%m-%d %H:%M:%S"),
                "lastSeen": "",
                "online": False
            })
            save(ACCOUNTS, accounts)
            self._json(200, {"ok": True, "message": "注册成功"})
        elif self.path.startswith("/api/login"):
            d = self._body()
            u, p = d.get("username", "").strip(), d.get("password", "")
            h = hashlib.sha256(p.encode()).hexdigest()
            accounts = load(ACCOUNTS, [])
            if not any(a.get("username") == u and a.get("password") == h for a in accounts):
                return self._json(401, {"ok": False, "error": "用户名或密码错误"})
            token = uuid.uuid4().hex
            sessions = load(SESSIONS, {})
            sessions[token] = {"username": u, "lastSeen": time.time()}
            save(SESSIONS, sessions)
            self._json(200, {"ok": True, "token": token, "username": u})
        elif self.path.startswith("/api/heartbeat"):
            d = self._body()
            sessions = load(SESSIONS, {})
            s = sessions.get(d.get("token", ""))
            if not s:
                return self._json(401, {"ok": False, "error": "会话失效，请重新登录"})
            s["lastSeen"] = time.time()
            save(SESSIONS, sessions)
            self._json(200, {"ok": True, "online": True})
        elif self.path.startswith("/api/logout"):
            d = self._body()
            sessions = load(SESSIONS, {})
            sessions.pop(d.get("token", ""), None)
            save(SESSIONS, sessions)
            self._json(200, {"ok": True})
        else:
            self._json(404, {"ok": False, "error": "unknown api"})

    def log_message(self, fmt, *args):
        print("[user_server]", self.address_string(), fmt % args, flush=True)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))
    os.makedirs(WWW, exist_ok=True)
    refresh_online()
    print("[user_server] listening on 0.0.0.0:%d" % port, flush=True)
    ThreadingHTTPServer(("0.0.0.0", port), Handler).serve_forever()
