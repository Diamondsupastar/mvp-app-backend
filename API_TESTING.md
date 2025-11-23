# API Testing Guide

## Test with curl

### 1. Signup
```bash
curl -X POST http://localhost:8080/api/users/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "Test User"
  }'
```

Response:
```json
{
  "token": "eyJhbGc...",
  "user": {
    "id": "uuid",
    "email": "test@example.com",
    "name": "Test User",
    "preferences": null
  }
}
```

### 2. Login
```bash
curl -X POST http://localhost:8080/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 3. Get Profile (requires token)
```bash
curl -X GET http://localhost:8080/api/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 4. Update Profile (requires token)
```bash
curl -X PUT http://localhost:8080/api/users/profile \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Name",
    "preferences": "Dark mode, notifications enabled"
  }'
```

### 5. Health Check
```bash
curl http://localhost:8080/health
```

## Common Errors

- **401 Unauthorized**: Token missing or invalid
- **400 Bad Request**: Email already registered or validation error
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server error

## Testing Flow

1. Start backend: `cd Backend && ./run.sh`
2. Create account via signup
3. Copy the token from response
4. Use token for authenticated requests
5. Test profile update
6. Test login with same credentials
