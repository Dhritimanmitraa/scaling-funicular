# 🗄️ Database Setup Guide for Gyan-Ai

This guide will help you set up a database for your Gyan-Ai backend.

## 🚀 **Quick Setup (Recommended)**

### **Option 1: Free Neon Database (5 minutes)**

1. **Get Free Database:**
   - Go to [neon.tech](https://neon.tech)
   - Click "Sign Up" (completely free)
   - Create a new project
   - Copy the connection string

2. **Configure Backend:**
   ```bash
   npm run setup:db
   ```
   - Choose option 1 (Neon)
   - Paste your connection string

3. **Set Up Database:**
   ```bash
   npm run migrate
   npm run seed
   ```

4. **Start Server:**
   ```bash
   npm run dev
   ```

**That's it! Your database is ready! 🎉**

---

## 🔧 **Alternative Options**

### **Option 2: Local PostgreSQL**

1. **Install PostgreSQL:**
   - Download from [postgresql.org](https://postgresql.org)
   - Install and create a database named `gyanai`

2. **Configure:**
   ```bash
   npm run setup:db
   ```
   - Choose option 2 (Local PostgreSQL)
   - Enter your database details

### **Option 3: SQLite (Local File)**

1. **Configure:**
   ```bash
   npm run setup:db
   ```
   - Choose option 3 (SQLite)
   - No additional setup needed

---

## 📊 **What Gets Created**

The database setup will create these tables:

- **`users`** - User accounts and profiles
- **`boards`** - Educational boards (CBSE, ICSE, etc.)
- **`classes`** - Grade levels (1-12)
- **`subjects`** - Subjects (Physics, Chemistry, etc.)
- **`chapters`** - Chapter information
- **`content`** - AI-generated content
- **`user_progress`** - Learning progress tracking
- **`quiz_attempts`** - Quiz results and scores

## 🌱 **Initial Data**

The seed script will populate:
- ✅ All major educational boards
- ✅ Grade levels 1-12
- ✅ Core subjects (Physics, Chemistry, Biology, Math, etc.)
- ✅ Sample chapters for each subject

## 🧪 **Testing Your Database**

After setup, test with:
```bash
npm run test:ai
```

## 🆘 **Troubleshooting**

### **Connection Issues:**
- Check your connection string
- Ensure database server is running
- Verify credentials

### **Migration Issues:**
- Run `npm run db:reset` to start fresh
- Check database permissions

### **Need Help?**
- Check the logs in your terminal
- Verify your `.env` file has the correct `NEON_DATABASE_URL`

---

## 🎯 **Next Steps**

Once your database is set up:

1. ✅ **Test the connection**
2. ✅ **Run your Flutter app**
3. ✅ **Register a new user**
4. ✅ **Generate AI quizzes**
5. ✅ **Track learning progress**

**Your Gyan-Ai platform will be fully functional! 🚀**
