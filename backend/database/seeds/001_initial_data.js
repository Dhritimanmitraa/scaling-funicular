exports.seed = async function(knex) {
  // Deletes ALL existing entries
  await knex('quiz_attempts').del();
  await knex('user_progress').del();
  await knex('content').del();
  await knex('chapters').del();
  await knex('subjects').del();
  await knex('classes').del();
  await knex('boards').del();
  await knex('users').del();

  // Inserts seed entries
  await knex('boards').insert([
    {
      id: 'board-cbse',
      name: 'CBSE',
      description: 'Central Board of Secondary Education',
      is_active: true
    },
    {
      id: 'board-icse',
      name: 'ICSE',
      description: 'Indian Certificate of Secondary Education',
      is_active: true
    },
    {
      id: 'board-state',
      name: 'State Board',
      description: 'State Education Board',
      is_active: true
    }
  ]);

  await knex('classes').insert([
    { id: 'class-1', name: 'Class 1', grade: 1, is_active: true },
    { id: 'class-2', name: 'Class 2', grade: 2, is_active: true },
    { id: 'class-3', name: 'Class 3', grade: 3, is_active: true },
    { id: 'class-4', name: 'Class 4', grade: 4, is_active: true },
    { id: 'class-5', name: 'Class 5', grade: 5, is_active: true },
    { id: 'class-6', name: 'Class 6', grade: 6, is_active: true },
    { id: 'class-7', name: 'Class 7', grade: 7, is_active: true },
    { id: 'class-8', name: 'Class 8', grade: 8, is_active: true },
    { id: 'class-9', name: 'Class 9', grade: 9, is_active: true },
    { id: 'class-10', name: 'Class 10', grade: 10, is_active: true },
    { id: 'class-11', name: 'Class 11', grade: 11, is_active: true },
    { id: 'class-12', name: 'Class 12', grade: 12, is_active: true }
  ]);

  await knex('subjects').insert([
    {
      id: 'subject-physics',
      name: 'Physics',
      description: 'Physical Sciences',
      icon: '⚛️',
      is_active: true
    },
    {
      id: 'subject-chemistry',
      name: 'Chemistry',
      description: 'Chemical Sciences',
      icon: '🧪',
      is_active: true
    },
    {
      id: 'subject-biology',
      name: 'Biology',
      description: 'Life Sciences',
      icon: '🧬',
      is_active: true
    },
    {
      id: 'subject-mathematics',
      name: 'Mathematics',
      description: 'Mathematical Sciences',
      icon: '📐',
      is_active: true
    },
    {
      id: 'subject-english',
      name: 'English',
      description: 'English Language and Literature',
      icon: '📚',
      is_active: true
    },
    {
      id: 'subject-hindi',
      name: 'Hindi',
      description: 'Hindi Language and Literature',
      icon: '📖',
      is_active: true
    },
    {
      id: 'subject-history',
      name: 'History',
      description: 'Historical Studies',
      icon: '🏛️',
      is_active: true
    },
    {
      id: 'subject-geography',
      name: 'Geography',
      description: 'Geographical Studies',
      icon: '🌍',
      is_active: true
    },
    {
      id: 'subject-economics',
      name: 'Economics',
      description: 'Economic Studies',
      icon: '💰',
      is_active: true
    },
    {
      id: 'subject-computer',
      name: 'Computer Science',
      description: 'Computer and Information Technology',
      icon: '💻',
      is_active: true
    }
  ]);

  await knex('chapters').insert([
    // Physics Chapters for Class 9
    {
      id: 'chapter-motion-9',
      name: 'Motion',
      description: 'Understanding motion, speed, velocity, and acceleration',
      subject_id: 'subject-physics',
      class_id: 'class-9',
      order: 1,
      is_active: true
    },
    {
      id: 'chapter-force-9',
      name: 'Force and Laws of Motion',
      description: 'Newton\'s laws of motion and their applications',
      subject_id: 'subject-physics',
      class_id: 'class-9',
      order: 2,
      is_active: true
    },
    {
      id: 'chapter-gravitation-9',
      name: 'Gravitation',
      description: 'Universal law of gravitation and its effects',
      subject_id: 'subject-physics',
      class_id: 'class-9',
      order: 3,
      is_active: true
    },
    {
      id: 'chapter-work-energy-9',
      name: 'Work and Energy',
      description: 'Work, energy, and power concepts',
      subject_id: 'subject-physics',
      class_id: 'class-9',
      order: 4,
      is_active: true
    },
    {
      id: 'chapter-sound-9',
      name: 'Sound',
      description: 'Properties and characteristics of sound',
      subject_id: 'subject-physics',
      class_id: 'class-9',
      order: 5,
      is_active: true
    },

    // Chemistry Chapters for Class 9
    {
      id: 'chapter-matter-9',
      name: 'Matter in Our Surroundings',
      description: 'States of matter and their properties',
      subject_id: 'subject-chemistry',
      class_id: 'class-9',
      order: 1,
      is_active: true
    },
    {
      id: 'chapter-atoms-9',
      name: 'Atoms and Molecules',
      description: 'Basic structure of atoms and molecules',
      subject_id: 'subject-chemistry',
      class_id: 'class-9',
      order: 2,
      is_active: true
    },
    {
      id: 'chapter-structure-9',
      name: 'Structure of the Atom',
      description: 'Atomic structure and electron configuration',
      subject_id: 'subject-chemistry',
      class_id: 'class-9',
      order: 3,
      is_active: true
    },

    // Biology Chapters for Class 9
    {
      id: 'chapter-cell-9',
      name: 'The Fundamental Unit of Life',
      description: 'Cell structure and functions',
      subject_id: 'subject-biology',
      class_id: 'class-9',
      order: 1,
      is_active: true
    },
    {
      id: 'chapter-tissues-9',
      name: 'Tissues',
      description: 'Plant and animal tissues',
      subject_id: 'subject-biology',
      class_id: 'class-9',
      order: 2,
      is_active: true
    },
    {
      id: 'chapter-diversity-9',
      name: 'Diversity in Living Organisms',
      description: 'Classification of living organisms',
      subject_id: 'subject-biology',
      class_id: 'class-9',
      order: 3,
      is_active: true
    },

    // Mathematics Chapters for Class 9
    {
      id: 'chapter-number-systems-9',
      name: 'Number Systems',
      description: 'Real numbers and their properties',
      subject_id: 'subject-mathematics',
      class_id: 'class-9',
      order: 1,
      is_active: true
    },
    {
      id: 'chapter-polynomials-9',
      name: 'Polynomials',
      description: 'Algebraic expressions and polynomials',
      subject_id: 'subject-mathematics',
      class_id: 'class-9',
      order: 2,
      is_active: true
    },
    {
      id: 'chapter-coordinate-geometry-9',
      name: 'Coordinate Geometry',
      description: 'Cartesian plane and coordinate systems',
      subject_id: 'subject-mathematics',
      class_id: 'class-9',
      order: 3,
      is_active: true
    },
    {
      id: 'chapter-linear-equations-9',
      name: 'Linear Equations in Two Variables',
      description: 'Solving linear equations with two variables',
      subject_id: 'subject-mathematics',
      class_id: 'class-9',
      order: 4,
      is_active: true
    },

    // Class 10 Chapters
    {
      id: 'chapter-light-10',
      name: 'Light - Reflection and Refraction',
      description: 'Properties of light and optical phenomena',
      subject_id: 'subject-physics',
      class_id: 'class-10',
      order: 1,
      is_active: true
    },
    {
      id: 'chapter-electricity-10',
      name: 'Electricity',
      description: 'Electric current, potential, and circuits',
      subject_id: 'subject-physics',
      class_id: 'class-10',
      order: 2,
      is_active: true
    },
    {
      id: 'chapter-magnetic-effects-10',
      name: 'Magnetic Effects of Electric Current',
      description: 'Electromagnetism and magnetic fields',
      subject_id: 'subject-physics',
      class_id: 'class-10',
      order: 3,
      is_active: true
    }
  ]);
};
