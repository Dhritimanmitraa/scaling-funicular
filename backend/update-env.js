#!/usr/bin/env node

const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log('🔧 Gyan-Ai Environment Configuration\n');

async function updateEnvFile() {
  try {
    // Read current .env file
    let envContent = fs.readFileSync('.env', 'utf8');
    
    console.log('📝 Let\'s configure your environment variables:\n');
    
    // Get Groq API Key
    const groqKey = await askQuestion('Enter your Groq API Key (or press Enter to skip): ');
    if (groqKey && groqKey.trim() !== '') {
      envContent = envContent.replace('GROQ_API_KEY=your_groq_api_key_here', `GROQ_API_KEY=${groqKey.trim()}`);
      console.log('✅ Groq API Key updated!\n');
    }
    
    // Get Hugging Face Token
    const hfToken = await askQuestion('Enter your Hugging Face Token (or press Enter to skip): ');
    if (hfToken && hfToken.trim() !== '') {
      envContent = envContent.replace('HUGGINGFACE_API_KEY=your_huggingface_token_here', `HUGGINGFACE_API_KEY=${hfToken.trim()}`);
      console.log('✅ Hugging Face Token updated!\n');
    }
    
    // Get RunwayML API Key
    const runwayKey = await askQuestion('Enter your RunwayML API Key (or press Enter to skip): ');
    if (runwayKey && runwayKey.trim() !== '') {
      envContent = envContent.replace('RUNWAY_API_KEY=your_runway_api_key_here', `RUNWAY_API_KEY=${runwayKey.trim()}`);
      console.log('✅ RunwayML API Key updated!\n');
    }
    
    // Get JWT Secret
    const jwtSecret = await askQuestion('Enter a JWT Secret (or press Enter to use default): ');
    if (jwtSecret && jwtSecret.trim() !== '') {
      envContent = envContent.replace('JWT_SECRET=your-super-secret-jwt-key-here', `JWT_SECRET=${jwtSecret.trim()}`);
      console.log('✅ JWT Secret updated!\n');
    }
    
    // Get Database URL
    const dbUrl = await askQuestion('Enter your Neon Database URL (or press Enter to use placeholder): ');
    if (dbUrl && dbUrl.trim() !== '') {
      envContent = envContent.replace('NEON_DATABASE_URL=postgresql://username:password@ep-xxx-xxx.us-east-1.aws.neon.tech/gyanai?sslmode=require', `NEON_DATABASE_URL=${dbUrl.trim()}`);
      console.log('✅ Database URL updated!\n');
    }
    
    // Write updated .env file
    fs.writeFileSync('.env', envContent);
    
    console.log('🎉 Environment configuration complete!');
    console.log('\n📋 Next steps:');
    console.log('1. Run: npm run migrate (to set up database)');
    console.log('2. Run: npm run seed (to add initial data)');
    console.log('3. Run: npm run dev (to start the server)');
    console.log('4. Test: npm run test:ai (to test AI services)');
    
  } catch (error) {
    console.error('❌ Error updating environment:', error.message);
  } finally {
    rl.close();
  }
}

function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

updateEnvFile();
