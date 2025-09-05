#!/usr/bin/env node

const { db, testConnection } = require('./src/config/database');
const knex = require('knex');
const knexConfig = require('./knexfile');

async function setupDatabase() {
  console.log('🚀 Setting up Gyan-Ai database...\n');

  try {
    // Test database connection
    console.log('1. Testing database connection...');
    const isConnected = await testConnection();
    if (!isConnected) {
      console.error('❌ Database connection failed. Please check your database configuration.');
      process.exit(1);
    }
    console.log('✅ Database connection successful\n');

    // Run migrations
    console.log('2. Running database migrations...');
    const environment = process.env.NODE_ENV || 'development';
    const config = knexConfig[environment];
    const knexInstance = knex(config);
    
    await knexInstance.migrate.latest();
    console.log('✅ Migrations completed successfully\n');

    // Seed initial data
    console.log('3. Seeding initial data...');
    await knexInstance.seed.run();
    console.log('✅ Initial data seeded successfully\n');

    // Test the setup
    console.log('4. Testing setup...');
    const boards = await db('boards').select('*');
    const classes = await db('classes').select('*');
    const subjects = await db('subjects').select('*');
    const chapters = await db('chapters').select('*');

    console.log(`✅ Found ${boards.length} boards`);
    console.log(`✅ Found ${classes.length} classes`);
    console.log(`✅ Found ${subjects.length} subjects`);
    console.log(`✅ Found ${chapters.length} chapters\n`);

    console.log('🎉 Database setup completed successfully!');
    console.log('\nYou can now start the server with: npm run dev');

    await knexInstance.destroy();
    process.exit(0);
  } catch (error) {
    console.error('❌ Database setup failed:', error.message);
    console.error('\nFull error:', error);
    process.exit(1);
  }
}

// Run setup if this file is executed directly
if (require.main === module) {
  setupDatabase();
}

module.exports = setupDatabase;