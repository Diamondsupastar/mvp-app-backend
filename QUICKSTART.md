# Quick Start Guide

## 🚀 Get Running in 5 Minutes

### Step 1: Start the Backend (Terminal 1)

```bash
cd ~/MVPApp/Backend
swift run
```

Wait for: `Server starting on http://127.0.0.1:8080`

### Step 2: Open iOS App in Xcode

```bash
open ~/MVPApp/iOS/MVPApp.xcodeproj
```

### Step 3: Configure Signing

1. Select "MVPApp" project in left sidebar
2. Select "MVPApp" target
3. Go to "Signing & Capabilities" tab
4. Select your Team from dropdown
5. Change Bundle Identifier if needed (e.g., `com.yourname.mvpapp`)

### Step 4: Run the App

1. Select iPhone simulator (e.g., iPhone 15 Pro)
2. Press ⌘R or click Run button
3. App launches in simulator

### Step 5: Test the App

1. Click "Don't have an account? Sign Up"
2. Fill in:
   - Name: Test User
   - Email: test@example.com
   - Password: password123
   - Confirm: password123
3. Click "Sign Up"
4. You're logged in! 🎉
5. Click "Edit Profile" to update your info
6. Click "Sign Out" to test login

## 📱 Testing on Physical Device

### For Simulator Testing
Backend URL is already configured for `localhost:8080`

### For Physical Device Testing

1. Find your Mac's local IP:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

2. Edit `iOS/MVPApp/Services/APIService.swift`:
```swift
private let baseURL = "http://YOUR_MAC_IP:8080"  // e.g., http://192.168.1.100:8080
```

3. Rebuild and run on device

## 🔧 Troubleshooting

### Backend won't start
```bash
# Install Swift if needed
xcode-select --install

# Clean and rebuild
cd Backend
rm -rf .build
swift build
swift run
```

### Xcode build errors
- Clean build folder: Shift+⌘K
- Close and reopen Xcode
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Network errors in app
- Ensure backend is running
- Check backend URL in APIService.swift
- For device: use Mac's local IP, not localhost

### Signing errors
- Select your Apple ID team
- Change Bundle Identifier to unique value
- Ensure certificates are valid

## 📝 Default Test Account

After first signup, you can login with:
- Email: test@example.com
- Password: password123

## 🎯 Next Steps

1. ✅ App runs locally
2. 📖 Read `README.md` for full documentation
3. 🚀 Read `PRODUCTION.md` for App Store deployment
4. 🧪 Read `API_TESTING.md` for API testing

## 💡 Tips

- Backend data stored in `Backend/db.sqlite`
- Delete database to reset: `rm Backend/db.sqlite`
- View logs in Xcode console
- Backend logs in terminal

## 🆘 Still Having Issues?

Check that:
- [ ] Xcode is installed (15.0+)
- [ ] Swift is installed (`swift --version`)
- [ ] Backend is running on port 8080
- [ ] No firewall blocking localhost
- [ ] Signing configured in Xcode
