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

  // Insert classes for each board (CBSE, ICSE, State Board)
  const boards = ['board-cbse', 'board-icse', 'board-state'];
  const classes = [];
  
  for (const boardId of boards) {
    for (let grade = 1; grade <= 12; grade++) {
      classes.push({
        id: `${boardId}-class-${grade}`,
        board_id: boardId,
        class_number: grade,
        is_active: true
      });
    }
  }
  
  await knex('classes').insert(classes);

  // Insert subjects for each class
  const subjects = [];
  const subjectTemplates = [
    { name: 'Physics', description: 'Physical Sciences', icon: '⚛️' },
    { name: 'Chemistry', description: 'Chemical Sciences', icon: '🧪' },
    { name: 'Biology', description: 'Life Sciences', icon: '🧬' },
    { name: 'Mathematics', description: 'Mathematical Sciences', icon: '📐' },
    { name: 'English', description: 'English Language and Literature', icon: '📚' },
    { name: 'Hindi', description: 'Hindi Language and Literature', icon: '📖' },
    { name: 'History', description: 'Historical Studies', icon: '🏛️' },
    { name: 'Geography', description: 'Geographical Studies', icon: '🌍' },
    { name: 'Economics', description: 'Economic Studies', icon: '💰' },
    { name: 'Computer Science', description: 'Computer and Information Technology', icon: '💻' }
  ];

  for (const boardId of boards) {
    for (let grade = 1; grade <= 12; grade++) {
      const classId = `${boardId}-class-${grade}`;
      
      // Add core subjects for all classes
      for (const subject of subjectTemplates) {
        subjects.push({
          id: `${classId}-${subject.name.toLowerCase().replace(' ', '-')}`,
          class_id: classId,
          name: subject.name,
          description: subject.description,
          icon: subject.icon,
          is_active: true
        });
      }
    }
  }
  
  await knex('subjects').insert(subjects);

  // Insert chapters for each subject and class
  const chapters = [];
  
  // Define chapter templates for each subject by class
  const chapterTemplates = {
    'physics': {
      9: [
        { name: 'Motion', description: 'Understanding motion, speed, velocity, and acceleration' },
        { name: 'Force and Laws of Motion', description: 'Newton\'s laws of motion and their applications' },
        { name: 'Gravitation', description: 'Universal law of gravitation and its effects' },
        { name: 'Work and Energy', description: 'Work, energy, and power concepts' },
        { name: 'Sound', description: 'Properties and characteristics of sound' }
      ],
      10: [
        { name: 'Light - Reflection and Refraction', description: 'Properties of light and optical phenomena' },
        { name: 'Electricity', description: 'Electric current, potential, and circuits' },
        { name: 'Magnetic Effects of Electric Current', description: 'Electromagnetism and magnetic fields' },
        { name: 'Sources of Energy', description: 'Renewable and non-renewable energy sources' }
      ],
      11: [
        { name: 'Physical World and Measurement', description: 'Fundamental concepts and units' },
        { name: 'Kinematics', description: 'Motion in one and two dimensions' },
        { name: 'Laws of Motion', description: 'Newton\'s laws and their applications' },
        { name: 'Work, Energy and Power', description: 'Energy conservation and power' },
        { name: 'Motion of System of Particles', description: 'Center of mass and rotational motion' }
      ],
      12: [
        { name: 'Electric Charges and Fields', description: 'Electrostatics and electric fields' },
        { name: 'Electrostatic Potential and Capacitance', description: 'Electric potential and capacitors' },
        { name: 'Current Electricity', description: 'Electric current and resistance' },
        { name: 'Moving Charges and Magnetism', description: 'Magnetic fields and forces' },
        { name: 'Electromagnetic Induction', description: 'Faraday\'s law and electromagnetic induction' }
      ]
    },
    'chemistry': {
      9: [
        { name: 'Matter in Our Surroundings', description: 'States of matter and their properties' },
        { name: 'Atoms and Molecules', description: 'Basic structure of atoms and molecules' },
        { name: 'Structure of the Atom', description: 'Atomic structure and electron configuration' }
      ],
      10: [
        { name: 'Chemical Reactions and Equations', description: 'Types of chemical reactions' },
        { name: 'Acids, Bases and Salts', description: 'Properties and reactions of acids and bases' },
        { name: 'Metals and Non-metals', description: 'Properties and uses of metals and non-metals' },
        { name: 'Carbon and its Compounds', description: 'Organic chemistry basics' }
      ],
      11: [
        { name: 'Some Basic Concepts of Chemistry', description: 'Fundamental concepts and calculations' },
        { name: 'Structure of Atom', description: 'Atomic models and quantum mechanics' },
        { name: 'Classification of Elements', description: 'Periodic table and periodicity' },
        { name: 'Chemical Bonding', description: 'Types of chemical bonds' }
      ],
      12: [
        { name: 'Solutions', description: 'Types of solutions and colligative properties' },
        { name: 'Electrochemistry', description: 'Redox reactions and electrochemical cells' },
        { name: 'Chemical Kinetics', description: 'Rate of chemical reactions' },
        { name: 'Surface Chemistry', description: 'Adsorption and catalysis' }
      ]
    },
    'mathematics': {
      9: [
        { name: 'Number Systems', description: 'Real numbers and their properties' },
        { name: 'Polynomials', description: 'Algebraic expressions and polynomials' },
        { name: 'Coordinate Geometry', description: 'Cartesian plane and coordinate systems' },
        { name: 'Linear Equations in Two Variables', description: 'Solving linear equations with two variables' }
      ],
      10: [
        { name: 'Real Numbers', description: 'Properties of real numbers' },
        { name: 'Polynomials', description: 'Polynomial functions and their properties' },
        { name: 'Pair of Linear Equations', description: 'Systems of linear equations' },
        { name: 'Quadratic Equations', description: 'Solving quadratic equations' }
      ],
      11: [
        { name: 'Sets', description: 'Set theory and operations' },
        { name: 'Relations and Functions', description: 'Mathematical relations and functions' },
        { name: 'Trigonometric Functions', description: 'Trigonometry and its applications' },
        { name: 'Principle of Mathematical Induction', description: 'Proof techniques' }
      ],
      12: [
        { name: 'Relations and Functions', description: 'Advanced function concepts' },
        { name: 'Inverse Trigonometric Functions', description: 'Inverse trig functions and their properties' },
        { name: 'Matrices', description: 'Matrix operations and applications' },
        { name: 'Determinants', description: 'Determinants and their properties' }
      ]
    }
  };

  // Generate chapters for each board, class, and subject
  for (const boardId of boards) {
    for (let grade = 9; grade <= 12; grade++) {
      const classId = `${boardId}-class-${grade}`;
      
      for (const [subjectName, gradeChapters] of Object.entries(chapterTemplates)) {
        if (gradeChapters[grade]) {
          const subjectId = `${classId}-${subjectName}`;
          
          gradeChapters[grade].forEach((chapter, index) => {
            chapters.push({
              id: `${subjectId}-${chapter.name.toLowerCase().replace(/[^a-z0-9]/g, '-')}`,
              subject_id: subjectId,
              name: chapter.name,
              description: chapter.description,
              chapter_number: index + 1,
              is_active: true
            });
          });
        }
      }
    }
  }
  
  await knex('chapters').insert(chapters);
};
