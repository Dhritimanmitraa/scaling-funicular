# 🆓 Free AI Services Setup Guide for Gyan-Ai

This guide will help you set up **completely free** AI services for quiz generation and video creation in your Gyan-Ai backend.

## 🎯 **What We're Using (100% Free)**

### **1. Quiz Generation**
- **Primary**: Groq API (14,400 requests/day free)
- **Backup**: Hugging Face (30,000 requests/month free)
- **Fallback**: Local quiz generation (unlimited, no API needed)

### **2. Video Generation**
- **Primary**: RunwayML (125 seconds/month free)
- **Backup**: Placeholder videos (unlimited, no API needed)
- **Future**: Local video generation with Stable Video Diffusion

---

## 🚀 **Step 1: Get Free API Keys**

### **Groq API (Recommended for Quiz Generation)**

1. **Sign up**: Go to [console.groq.com](https://console.groq.com)
2. **Create account**: Use your email (no credit card required)
3. **Get API key**: Go to API Keys section
4. **Copy key**: It will look like `gsk_...`

**Free Tier**: 14,400 requests per day (more than enough for development)

### **Hugging Face (Backup for Quiz Generation)**

1. **Sign up**: Go to [huggingface.co](https://huggingface.co)
2. **Create account**: Use your email
3. **Get token**: Go to Settings → Access Tokens
4. **Create token**: Click "New token"
5. **Copy token**: It will look like `hf_...`

**Free Tier**: 30,000 requests per month

### **RunwayML (For Video Generation)**

1. **Sign up**: Go to [runwayml.com](https://runwayml.com)
2. **Create account**: Use your email
3. **Get API key**: Go to Account → API Keys
4. **Copy key**: It will look like `rwy_...`

**Free Tier**: 125 seconds of video generation per month

---

## 🔧 **Step 2: Configure Your Backend**

### **Update Environment Variables**

Edit your `.env` file in the backend directory:

```env
# Free AI API Keys
HUGGINGFACE_API_KEY=hf_your_actual_token_here
GROQ_API_KEY=gsk_your_actual_key_here
RUNWAY_API_KEY=rwy_your_actual_key_here

# Other required variables
NEON_DATABASE_URL=your_neon_database_url
JWT_SECRET=your-super-secret-jwt-key-here
PORT=3000
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
```

### **Install Dependencies**

```bash
cd backend
npm install
```

---

## 🧪 **Step 3: Test the Setup**

### **Start the Backend**

```bash
npm run dev
```

### **Test Quiz Generation**

```bash
curl -X GET "http://localhost:3000/api/content/quiz/your-chapter-id" \
  -H "Authorization: Bearer your-jwt-token"
```

### **Test Video Generation**

```bash
curl -X GET "http://localhost:3000/api/content/video/your-chapter-id" \
  -H "Authorization: Bearer your-jwt-token"
```

---

## 📊 **Free Tier Limits & Usage**

### **Groq API**
- **Limit**: 14,400 requests/day
- **Cost**: $0 (completely free)
- **Models**: Llama 3, Mistral, etc.
- **Speed**: Very fast (sub-second responses)

### **Hugging Face**
- **Limit**: 30,000 requests/month
- **Cost**: $0 (completely free)
- **Models**: DialoGPT, GPT-2, etc.
- **Speed**: Moderate (1-3 seconds)

### **RunwayML**
- **Limit**: 125 seconds of video/month
- **Cost**: $0 (completely free)
- **Quality**: High quality videos
- **Speed**: 2-5 minutes per video

---

## 🔄 **Fallback System**

The backend includes **intelligent fallbacks**:

1. **Primary**: Try Groq API for quiz generation
2. **Backup**: Try Hugging Face if Groq fails
3. **Fallback**: Use local quiz generation (always works)

For videos:
1. **Primary**: Try RunwayML for video generation
2. **Fallback**: Use placeholder videos (always works)

---

## 💡 **Pro Tips for Free Usage**

### **Optimize API Calls**
- **Cache results**: Generated content is stored in database
- **Reuse content**: Same chapter = same quiz/video
- **Batch requests**: Generate multiple items at once

### **Monitor Usage**
- Check your API usage in each service dashboard
- Set up alerts when approaching limits
- Use fallback system when limits reached

### **Scale Up Later**
- When you're ready to scale, you can upgrade to paid plans
- All paid services are already configured in the code
- Just uncomment and add your paid API keys

---

## 🛠️ **Alternative: 100% Local Setup**

If you want **zero API costs**, you can run everything locally:

### **Local Quiz Generation**
- Already implemented in the fallback system
- No API calls required
- Works offline

### **Local Video Generation** (Advanced)
- Install Stable Video Diffusion locally
- Generate videos on your own machine
- No API limits or costs

---

## 🚨 **Troubleshooting**

### **API Key Issues**
```bash
# Check if keys are loaded
node -e "require('dotenv').config(); console.log(process.env.GROQ_API_KEY)"
```

### **Rate Limit Exceeded**
- The system automatically falls back to local generation
- Check your API usage in the service dashboards
- Wait for the limit to reset

### **Video Generation Fails**
- System automatically uses placeholder videos
- Check RunwayML API key and usage
- Videos are cached, so failures are rare

---

## 📈 **Scaling Up (When Ready)**

When you're ready to scale beyond free tiers:

### **Upgrade to Paid Plans**
- **Groq**: $0.27 per 1M tokens
- **Hugging Face**: $0.06 per 1K requests
- **RunwayML**: $0.05 per second

### **Alternative Paid Services**
- **OpenRouter**: Access to multiple models
- **Fal.ai**: High-quality video generation
- **Anthropic Claude**: Advanced reasoning

---

## ✅ **Quick Start Checklist**

- [ ] Sign up for Groq API (free)
- [ ] Sign up for Hugging Face (free)
- [ ] Sign up for RunwayML (free)
- [ ] Update `.env` with API keys
- [ ] Run `npm install` in backend
- [ ] Start backend with `npm run dev`
- [ ] Test quiz generation
- [ ] Test video generation
- [ ] Deploy and enjoy! 🎉

---

## 🎯 **Expected Results**

With this setup, you'll have:
- ✅ **Unlimited quiz generation** (with intelligent fallbacks)
- ✅ **Video generation** (125 seconds/month free)
- ✅ **No credit card required**
- ✅ **Production-ready system**
- ✅ **Easy to scale up later**

Your Gyan-Ai backend will work perfectly with these free services! 🚀
