const { db, testConnection } = require('../config/database');

const connectDatabase = async () => {
  const isConnected = await testConnection();
  if (!isConnected) {
    throw new Error('Failed to connect to database');
  }
  return db;
};

const runMigrations = async () => {
  try {
    console.log('🔄 Running database migrations...');
    await db.migrate.latest();
    console.log('✅ Database migrations completed');
  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  }
};

const seedDatabase = async () => {
  try {
    console.log('🌱 Seeding database...');
    await db.seed.run();
    console.log('✅ Database seeding completed');
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    throw error;
  }
};

module.exports = {
  connectDatabase,
  runMigrations,
  seedDatabase,
  db
};
