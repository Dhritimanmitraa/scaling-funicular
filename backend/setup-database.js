#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log('🗄️  Gyan-Ai Database Setup\n');

async function setupDatabase() {
  try {
    console.log('📋 Database Options:');
    console.log('1. Neon (Free PostgreSQL) - Recommended');
    console.log('2. Local PostgreSQL');
    console.log('3. SQLite (Local file)');
    console.log('4. Skip database setup\n');
    
    const choice = await askQuestion('Choose an option (1-4): ');
    
    switch (choice) {
      case '1':
        await setupNeonDatabase();
        break;
      case '2':
        await setupLocalPostgreSQL();
        break;
      case '3':
        await setupSQLite();
        break;
      case '4':
        console.log('⏭️  Skipping database setup');
        break;
      default:
        console.log('❌ Invalid choice');
        return;
    }
    
  } catch (error) {
    console.error('❌ Setup failed:', error.message);
  } finally {
    rl.close();
  }
}

async function setupNeonDatabase() {
  console.log('\n🌐 Setting up Neon Database...');
  console.log('\n📝 Steps to get your free Neon database:');
  console.log('1. Go to: https://neon.tech');
  console.log('2. Click "Sign Up" (free tier available)');
  console.log('3. Create a new project');
  console.log('4. Copy the connection string');
  console.log('5. Paste it below\n');
  
  const connectionString = await askQuestion('Enter your Neon connection string: ');
  
  if (connectionString && connectionString.includes('postgresql://')) {
    // Update .env file
    let envContent = fs.readFileSync('.env', 'utf8');
    envContent = envContent.replace(
      'NEON_DATABASE_URL=postgresql://username:password@ep-xxx-xxx.us-east-1.aws.neon.tech/gyanai?sslmode=require',
      `NEON_DATABASE_URL=${connectionString}`
    );
    fs.writeFileSync('.env', envContent);
    
    console.log('✅ Database URL updated in .env file');
    console.log('\n🚀 Next steps:');
    console.log('1. Run: npm run migrate');
    console.log('2. Run: npm run seed');
    console.log('3. Start server: npm run dev');
  } else {
    console.log('❌ Invalid connection string');
  }
}

async function setupLocalPostgreSQL() {
  console.log('\n💻 Setting up Local PostgreSQL...');
  console.log('\n📝 Prerequisites:');
  console.log('1. Install PostgreSQL on your system');
  console.log('2. Create a database named "gyanai"');
  console.log('3. Note your username and password\n');
  
  const host = await askQuestion('Enter PostgreSQL host (default: localhost): ') || 'localhost';
  const port = await askQuestion('Enter PostgreSQL port (default: 5432): ') || '5432';
  const username = await askQuestion('Enter PostgreSQL username: ');
  const password = await askQuestion('Enter PostgreSQL password: ');
  const database = await askQuestion('Enter database name (default: gyanai): ') || 'gyanai';
  
  const connectionString = `postgresql://${username}:${password}@${host}:${port}/${database}`;
  
  // Update .env file
  let envContent = fs.readFileSync('.env', 'utf8');
  envContent = envContent.replace(
    'NEON_DATABASE_URL=postgresql://username:password@ep-xxx-xxx.us-east-1.aws.neon.tech/gyanai?sslmode=require',
    `NEON_DATABASE_URL=${connectionString}`
  );
  fs.writeFileSync('.env', envContent);
  
  console.log('✅ Database URL updated in .env file');
  console.log('\n🚀 Next steps:');
  console.log('1. Run: npm run migrate');
  console.log('2. Run: npm run seed');
  console.log('3. Start server: npm run dev');
}

async function setupSQLite() {
  console.log('\n📁 Setting up SQLite...');
  
  // Update .env file
  let envContent = fs.readFileSync('.env', 'utf8');
  envContent = envContent.replace(
    'NEON_DATABASE_URL=postgresql://username:password@ep-xxx-xxx.us-east-1.aws.neon.tech/gyanai?sslmode=require',
    'NEON_DATABASE_URL=sqlite://./database/gyanai.db'
  );
  fs.writeFileSync('.env', envContent);
  
  // Create database directory
  if (!fs.existsSync('./database')) {
    fs.mkdirSync('./database');
  }
  
  console.log('✅ SQLite database configured');
  console.log('📁 Database file: ./database/gyanai.db');
  console.log('\n🚀 Next steps:');
  console.log('1. Run: npm run migrate');
  console.log('2. Run: npm run seed');
  console.log('3. Start server: npm run dev');
}

function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

setupDatabase();
