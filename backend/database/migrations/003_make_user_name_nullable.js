exports.up = async function(knex) {
  // Make users.name nullable to match current frontend (no name on sign-up)
  const hasName = await knex.schema.hasColumn('users', 'name');
  if (hasName) {
    await knex.schema.raw('ALTER TABLE users ALTER COLUMN name DROP NOT NULL');
  }
};

exports.down = async function(knex) {
  const hasName = await knex.schema.hasColumn('users', 'name');
  if (hasName) {
    // Revert to NOT NULL; use empty string for existing nulls to avoid failure
    await knex.schema.raw("UPDATE users SET name = '' WHERE name IS NULL");
    await knex.schema.raw('ALTER TABLE users ALTER COLUMN name SET NOT NULL');
  }
};

