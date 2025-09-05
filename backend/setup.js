#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

console.log('🚀 Setting up Gyan-Ai Backend...\n');

// Check if .env exists
const envPath = path.join(__dirname, '.env');
if (!fs.existsSync(envPath)) {
  console.log('📝 Creating .env file from template...');
  fs.copyFileSync(path.join(__dirname, 'env.example'), envPath);
  console.log('✅ .env file created. Please update it with your actual values.\n');
} else {
  console.log('✅ .env file already exists.\n');
}

// Install dependencies
console.log('📦 Installing dependencies...');
try {
  execSync('npm install', { stdio: 'inherit' });
  console.log('✅ Dependencies installed successfully.\n');
} catch (error) {
  console.error('❌ Failed to install dependencies:', error.message);
  process.exit(1);
}

// Check if database URL is configured
require('dotenv').config();
if (!process.env.NEON_DATABASE_URL || process.env.NEON_DATABASE_URL.includes('your_neon_database_url')) {
  console.log('⚠️  Please configure your database URL in .env file before running migrations.\n');
  console.log('📋 Next steps:');
  console.log('1. Update .env with your actual database URL and API keys');
  console.log('2. Run: npm run migrate');
  console.log('3. Run: npm run seed');
  console.log('4. Run: npm run dev');
} else {
  // Run migrations
  console.log('🗄️  Running database migrations...');
  try {
    execSync('npm run migrate', { stdio: 'inherit' });
    console.log('✅ Database migrations completed.\n');
  } catch (error) {
    console.error('❌ Migration failed:', error.message);
    console.log('Please check your database connection and try again.\n');
  }

  // Run seeds
  console.log('🌱 Seeding database...');
  try {
    execSync('npm run seed', { stdio: 'inherit' });
    console.log('✅ Database seeded successfully.\n');
  } catch (error) {
    console.error('❌ Seeding failed:', error.message);
  }
}

console.log('🎉 Backend setup completed!');
console.log('\n📋 Available commands:');
console.log('  npm run dev     - Start development server');
console.log('  npm start       - Start production server');
console.log('  npm test        - Run tests');
console.log('  npm run migrate - Run database migrations');
console.log('  npm run seed    - Seed database with initial data');
console.log('\n🔗 API will be available at: http://localhost:3000');
console.log('📊 Health check: http://localhost:3000/health');
