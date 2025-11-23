# 🚂 Railway Deployment Guide

## Quick Deploy (5 Minutes)

### Step 1: Create Railway Account

1. Go to **https://railway.app**
2. Click **"Start a New Project"**
3. Sign up with **GitHub** (recommended) or email

### Step 2: Initialize Git Repository

```bash
cd ~/MVPApp
git init
git add .
git commit -m "Initial commit - MVP App"
```

### Step 3: Push to GitHub

```bash
# Create new repo on GitHub: https://github.com/new
# Name it: mvp-app-backend
# Then:

git remote add origin https://github.com/YOUR_USERNAME/mvp-app-backend.git
git branch -M main
git push -u origin main
```

### Step 4: Deploy on Railway

1. In Railway dashboard, click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose your `mvp-app-backend` repository
4. Railway will auto-detect Swift/Vapor
5. Click **"Deploy"**

### Step 5: Wait for Deployment

- Railway will:
  - ✅ Install Swift
  - ✅ Install dependencies
  - ✅ Compile your app
  - ✅ Start the server
- Takes ~5-10 minutes first time

### Step 6: Get Your URL

1. Once deployed, click on your service
2. Go to **"Settings"** tab
3. Click **"Generate Domain"**
4. Copy your URL (e.g., `https://your-app.up.railway.app`)

### Step 7: Test Your API

```bash
# Replace with your Railway URL
curl https://your-app.up.railway.app/health

# Should return: {"status":"ok"}
```

### Step 8: Update iOS App

1. Open `~/MVPApp/iOS/MVPApp/Services/APIService.swift`
2. Change line 18:
```swift
private let baseURL = "https://your-app.up.railway.app"
```
3. Rebuild iOS app in Xcode (⌘R)

## ✅ You're Done!

Your backend is now live and your iOS app can connect to it!

---

## Alternative: Railway CLI (Advanced)

```bash
# Install Railway CLI
brew install railway

# Login
railway login

# Deploy from Backend folder
cd ~/MVPApp/Backend
railway init
railway up
```

---

## Environment Variables (Optional)

In Railway dashboard → Settings → Variables:

```
JWT_SECRET=your-secure-random-secret-here
```

Then update `routes.swift`:
```swift
let jwtSecret = Environment.get("JWT_SECRET") ?? "secret-key-change-in-production"
app.jwt.signers.use(.hs256(key: jwtSecret))
```

---

## Troubleshooting

### Build fails
- Check Railway logs in dashboard
- Ensure Package.swift is correct
- Try redeploying

### App crashes
- Check logs for errors
- Verify PORT environment variable is used
- Check database migrations ran

### Can't connect from iOS
- Verify domain is generated
- Use HTTPS (not HTTP)
- Check URL in APIService.swift

---

## Cost

- **Free tier**: 500 hours/month, $5 credit
- **Paid**: $5/month after free credit
- Perfect for MVP testing!

---

## Next Steps

1. ✅ Deploy backend to Railway
2. ✅ Get production URL
3. ✅ Update iOS app
4. ✅ Test signup/login
5. ✅ Submit to App Store!
