# Production Deployment Guide

## iOS App - App Store Submission

### 1. Prepare App for Production

**Update Bundle Identifier**
- Open project in Xcode
- Select MVPApp target
- Change Bundle Identifier to your unique ID (e.g., `com.yourcompany.mvpapp`)

**Configure Signing**
- Select your Apple Developer Team
- Ensure "Automatically manage signing" is enabled
- Or manually select Distribution certificate

**Update Backend URL**
- Edit `iOS/MVPApp/Services/APIService.swift`
- Change `baseURL` from `http://localhost:8080` to your production API URL
- Example: `https://api.yourapp.com`

**Add App Icons**
- Create 1024x1024 PNG icon
- Drag to `Assets.xcassets/AppIcon.appiconset`
- Xcode will generate all required sizes

**Update Version & Build**
- Set Marketing Version (e.g., 1.0.0)
- Set Build Number (e.g., 1)

### 2. Create Archive

1. Select "Any iOS Device (arm64)" as destination
2. Menu: Product → Archive
3. Wait for archive to complete
4. Organizer window opens

### 3. Validate Archive

1. Select archive
2. Click "Validate App"
3. Follow wizard
4. Fix any issues reported

### 4. Upload to App Store Connect

1. Click "Distribute App"
2. Select "App Store Connect"
3. Select "Upload"
4. Follow wizard
5. Wait for upload to complete

### 5. App Store Connect Setup

**Create App**
- Go to https://appstoreconnect.apple.com
- Click "My Apps" → "+"
- Fill in app information
- Match Bundle ID exactly

**Fill Metadata**
- App name
- Subtitle
- Description
- Keywords
- Screenshots (required for all device sizes)
- Privacy policy URL
- Support URL

**Select Build**
- After upload processes (10-30 min)
- Select your uploaded build
- Answer export compliance questions

**Submit for Review**
- Complete all required fields
- Click "Submit for Review"
- Wait for Apple review (1-3 days typically)

## Backend - Production Deployment

### Option 1: Deploy to AWS (Recommended)

**Using EC2**
```bash
# SSH to EC2 instance
ssh -i your-key.pem ec2-user@your-instance

# Install Swift
# Follow: https://swift.org/install/linux/

# Clone your repo
git clone your-repo-url
cd Backend

# Build release
swift build -c release

# Run with systemd
sudo nano /etc/systemd/system/mvpapp.service
```

systemd service file:
```ini
[Unit]
Description=MVP App Backend
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/Backend
ExecStart=/home/ec2-user/Backend/.build/release/App
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable mvpapp
sudo systemctl start mvpapp
```

**Using Elastic Beanstalk**
- Package as Docker container
- Deploy via EB CLI

**Using ECS/Fargate**
- Create Docker image
- Push to ECR
- Deploy via ECS

### Option 2: Deploy to Heroku

```bash
# Install Heroku CLI
brew install heroku

# Login
heroku login

# Create app
heroku create your-app-name

# Add buildpack
heroku buildpacks:set vapor/vapor

# Deploy
git push heroku main
```

### Option 3: Deploy to Railway/Render

- Connect GitHub repo
- Select Swift/Vapor buildpack
- Deploy automatically

## Database - Production

### Migrate from SQLite to PostgreSQL

**Update Package.swift**
```swift
.package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
```

**Update main.swift**
```swift
app.databases.use(.postgres(
    hostname: Environment.get("DB_HOST") ?? "localhost",
    username: Environment.get("DB_USER") ?? "vapor",
    password: Environment.get("DB_PASSWORD") ?? "",
    database: Environment.get("DB_NAME") ?? "vapor"
), as: .psql)
```

**Use AWS RDS**
- Create PostgreSQL instance
- Configure security groups
- Update connection string

## Security Checklist

- [ ] Change JWT secret key (use environment variable)
- [ ] Enable HTTPS only
- [ ] Configure CORS properly
- [ ] Use strong passwords
- [ ] Enable rate limiting
- [ ] Add logging and monitoring
- [ ] Backup database regularly
- [ ] Use environment variables for secrets
- [ ] Enable App Transport Security (ATS) in iOS
- [ ] Add certificate pinning (optional)

## Environment Variables

Backend should use:
```bash
export JWT_SECRET="your-secure-random-secret"
export DB_HOST="your-db-host"
export DB_USER="your-db-user"
export DB_PASSWORD="your-db-password"
export DB_NAME="your-db-name"
export PORT="8080"
```

## Monitoring

- Use CloudWatch for AWS
- Add error tracking (Sentry, Rollbar)
- Monitor API response times
- Track user signups/logins
- Set up alerts for errors

## Scaling

- Use load balancer (ALB on AWS)
- Auto-scaling groups
- CDN for static assets
- Database read replicas
- Redis for caching/sessions

## Cost Estimates

Use AWS Pricing Calculator: https://calculator.aws

**Minimal Setup (~$20-50/month)**
- EC2 t3.micro: ~$8/month
- RDS db.t3.micro: ~$15/month
- Data transfer: ~$5/month

**Production Setup (~$100-200/month)**
- EC2 t3.small with auto-scaling
- RDS db.t3.small with backups
- Load balancer
- CloudWatch monitoring
