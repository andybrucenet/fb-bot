#!/usr/bin/env python
"""
Very simple HTTP server in python.
Usage::
  ./dummy-web-server.py [<port>]
Send a GET request::
  curl http://localhost
Send a HEAD request::
  curl -I http://localhost
Send a POST request::
  curl -d "foo=bar&bin=baz" http://localhost
"""
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import SocketServer
import sys

class S(BaseHTTPRequestHandler):
  def _set_headers(self):
    self.send_response(200)
    self.send_header('Content-type', 'text/html')
    self.end_headers()

  def do_GET(self):
    self._set_headers()
    self.wfile.write("<html><body><h1>get</h1></body></html>")

  def do_HEAD(self):
    self._set_headers()
    
  def do_POST(self):
    # Doesn't do anything with posted data
    content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
    post_data = self.rfile.read(content_length) # <--- Gets the data itself
    print post_data # <-- Print post data
    sys.stdout.flush()
    self._set_headers()
    self.wfile.write("<html><body><h1>post</h1></body></html>")
    
def run(server_class=HTTPServer, handler_class=S, port=8002):
  server_address = ('', port)
  httpd = server_class(server_address, handler_class)
  print 'Starting httpd...'
  httpd.serve_forever()

if __name__ == "__main__":
  from sys import argv

  if len(argv) == 2:
    run(port=int(argv[1]))
  else:
    run()

