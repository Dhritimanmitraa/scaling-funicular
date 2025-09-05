exports.up = async function(knex) {
  const hasBoard = await knex.schema.hasColumn('users', 'selected_board_id');
  if (!hasBoard) {
    await knex.schema.alterTable('users', function(table) {
      table.string('selected_board_id').nullable();
    });
  }

  const hasClass = await knex.schema.hasColumn('users', 'selected_class_id');
  if (!hasClass) {
    await knex.schema.alterTable('users', function(table) {
      table.string('selected_class_id').nullable();
    });
  }
};

exports.down = async function(knex) {
  const hasClass = await knex.schema.hasColumn('users', 'selected_class_id');
  if (hasClass) {
    await knex.schema.alterTable('users', function(table) {
      table.dropColumn('selected_class_id');
    });
  }

  const hasBoard = await knex.schema.hasColumn('users', 'selected_board_id');
  if (hasBoard) {
    await knex.schema.alterTable('users', function(table) {
      table.dropColumn('selected_board_id');
    });
  }
};

