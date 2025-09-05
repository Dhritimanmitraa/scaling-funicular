# 🚀 Gyan-Ai Backend Quick Start Guide

This guide will help you get your Gyan-Ai backend running with free AI services in just a few minutes!

## 📋 **Prerequisites**

- Node.js 18+ installed
- A text editor
- Internet connection

## ⚡ **Quick Setup (5 minutes)**

### **Step 1: Get Free API Keys**

#### **1.1 Groq API (Quiz Generation)**
1. Go to [console.groq.com](https://console.groq.com)
2. Sign up with your email (no credit card required)
3. Go to "API Keys" → "Create API Key"
4. Copy the key (starts with `gsk_`)

#### **1.2 Hugging Face (Backup Quiz Generation)**
1. Go to [huggingface.co](https://huggingface.co)
2. Sign up with your email
3. Go to Settings → Access Tokens → "New token"
4. Copy the token (starts with `hf_`)

#### **1.3 RunwayML (Video Generation)**
1. Go to [runwayml.com](https://runwayml.com)
2. Sign up with your email
3. Go to Account → API Keys → Create new key
4. Copy the key (starts with `rwy_`)

### **Step 2: Configure Environment**

Run the interactive setup script:

```bash
npm run setup:env
```

This will ask you for your API keys and update the `.env` file automatically.

**Or manually edit `.env` file:**

```env
# Free AI API Keys
GROQ_API_KEY=gsk_your_actual_key_here
HUGGINGFACE_API_KEY=hf_your_actual_token_here
RUNWAY_API_KEY=rwy_your_actual_key_here

# JWT Secret (generate a random string)
JWT_SECRET=your-super-secret-jwt-key-here

# Database (optional - will use fallback if not provided)
NEON_DATABASE_URL=your_neon_database_url_here
```

### **Step 3: Set Up Database (Optional)**

If you have a Neon database URL:

```bash
npm run migrate
npm run seed
```

**If you don't have a database yet:**
- The system will work with fallback content
- You can add a database later

### **Step 4: Start the Server**

```bash
npm run dev
```

Your backend will be running at: `http://localhost:3000`

### **Step 5: Test Everything**

```bash
npm run test:ai
```

## 🧪 **Test Your Setup**

### **Health Check**
```bash
curl http://localhost:3000/health
```

### **Test Quiz Generation**
```bash
curl -X GET "http://localhost:3000/api/content/quiz/test-chapter-id" \
  -H "Authorization: Bearer your-jwt-token"
```

### **Test Video Generation**
```bash
curl -X GET "http://localhost:3000/api/content/video/test-chapter-id" \
  -H "Authorization: Bearer your-jwt-token"
```

## 📊 **What You Get**

### **With API Keys:**
- ✅ AI-generated quizzes (Groq API)
- ✅ AI-generated video scripts (Groq API)
- ✅ AI-generated videos (RunwayML)
- ✅ High-quality, contextual content

### **Without API Keys (Fallback):**
- ✅ Pre-built quiz questions for all major topics
- ✅ Educational video scripts
- ✅ Placeholder videos
- ✅ Fully functional system

## 🔧 **Troubleshooting**

### **API Key Issues**
```bash
# Test if keys are loaded
node -e "require('dotenv').config(); console.log('Groq:', process.env.GROQ_API_KEY ? 'Set' : 'Not set');"
```

### **Database Issues**
```bash
# Reset database
npm run db:reset
```

### **Port Already in Use**
```bash
# Change port in .env file
PORT=3001
```

## 📱 **Connect to Frontend**

Update your Flutter app's API base URL to:
```
http://localhost:3000/api
```

## 🚀 **Deploy to Production**

### **Vercel (Recommended)**
1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel`
3. Add environment variables in Vercel dashboard
4. Deploy!

### **Railway**
1. Connect your GitHub repo to Railway
2. Add environment variables
3. Deploy automatically!

## 📈 **Monitor Usage**

### **Groq API**
- Dashboard: [console.groq.com](https://console.groq.com)
- Limit: 14,400 requests/day
- Usage: Check "Usage" tab

### **Hugging Face**
- Dashboard: [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)
- Limit: 30,000 requests/month
- Usage: Check API usage in settings

### **RunwayML**
- Dashboard: [runwayml.com/account](https://runwayml.com/account)
- Limit: 125 seconds/month
- Usage: Check usage in account settings

## 🎯 **Success Checklist**

- [ ] API keys obtained and configured
- [ ] Environment variables set
- [ ] Backend server running
- [ ] Health check passing
- [ ] AI services tested
- [ ] Frontend connected
- [ ] Ready for production!

## 🆘 **Need Help?**

1. **Check logs**: Look at console output for errors
2. **Test AI services**: Run `npm run test:ai`
3. **Check environment**: Verify `.env` file has correct values
4. **Restart server**: Stop and start with `npm run dev`

## 🎉 **You're Ready!**

Your Gyan-Ai backend is now fully functional with free AI services! 

**Next steps:**
1. Connect your Flutter frontend
2. Test the complete user flow
3. Deploy to production
4. Start building your educational platform!

---

**Happy coding! 🚀**
