#!/bin/bash

echo "Starting MVP Backend Server..."
echo "Server will run on http://localhost:8080"
echo ""
echo "Available endpoints:"
echo "  POST /api/users/signup"
echo "  POST /api/users/login"
echo "  GET  /api/users/profile (requires auth)"
echo "  PUT  /api/users/profile (requires auth)"
echo ""

swift run
