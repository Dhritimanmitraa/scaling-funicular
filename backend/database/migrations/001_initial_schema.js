exports.up = function(knex) {
  return knex.schema
    // Create boards table
    .createTable('boards', function(table) {
      table.string('id').primary();
      table.string('name').notNullable();
      table.text('description');
      table.boolean('is_active').defaultTo(true);
      table.timestamps(true, true);
    })
    
    // Create classes table
    .createTable('classes', function(table) {
      table.string('id').primary();
      table.string('name').notNullable();
      table.integer('grade').notNullable().unique();
      table.boolean('is_active').defaultTo(true);
      table.timestamps(true, true);
    })
    
    // Create subjects table
    .createTable('subjects', function(table) {
      table.string('id').primary();
      table.string('name').notNullable();
      table.text('description');
      table.string('icon');
      table.boolean('is_active').defaultTo(true);
      table.timestamps(true, true);
    })
    
    // Create chapters table
    .createTable('chapters', function(table) {
      table.string('id').primary();
      table.string('name').notNullable();
      table.text('description');
      table.string('subject_id').references('id').inTable('subjects');
      table.string('class_id').references('id').inTable('classes');
      table.integer('order').defaultTo(1);
      table.boolean('is_active').defaultTo(true);
      table.timestamps(true, true);
    })
    
    // Create users table
    .createTable('users', function(table) {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.string('name').notNullable();
      table.string('email').unique().notNullable();
      table.string('password_hash').notNullable();
      table.string('grade');
      table.string('board');
      table.jsonb('preferences').defaultTo('{}');
      table.boolean('is_active').defaultTo(true);
      table.timestamps(true, true);
    })
    
    // Create content table
    .createTable('content', function(table) {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.string('type').notNullable(); // 'video' or 'quiz'
      table.string('chapter_id').references('id').inTable('chapters');
      table.jsonb('data').notNullable(); // Content data
      table.string('status').defaultTo('active'); // 'active', 'archived'
      table.timestamps(true, true);
    })
    
    // Create user_progress table
    .createTable('user_progress', function(table) {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.uuid('user_id').references('id').inTable('users');
      table.string('chapter_id').references('id').inTable('chapters');
      table.uuid('content_id').references('id').inTable('content');
      table.string('status').defaultTo('not_started'); // 'not_started', 'in_progress', 'completed'
      table.integer('progress_percentage').defaultTo(0);
      table.timestamp('completed_at');
      table.timestamps(true, true);
      
      table.unique(['user_id', 'chapter_id', 'content_id']);
    })
    
    // Create quiz_attempts table
    .createTable('quiz_attempts', function(table) {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.uuid('user_id').references('id').inTable('users');
      table.string('chapter_id').references('id').inTable('chapters');
      table.uuid('content_id').references('id').inTable('content');
      table.jsonb('answers').notNullable(); // User's answers
      table.integer('score').notNullable();
      table.integer('total_questions').notNullable();
      table.timestamp('completed_at').defaultTo(knex.fn.now());
      table.timestamps(true, true);
    });
};

exports.down = function(knex) {
  return knex.schema
    .dropTable('quiz_attempts')
    .dropTable('user_progress')
    .dropTable('content')
    .dropTable('users')
    .dropTable('chapters')
    .dropTable('subjects')
    .dropTable('classes')
    .dropTable('boards');
};
