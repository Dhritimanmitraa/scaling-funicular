-- Insert educational boards
INSERT INTO boards (id, name) VALUES 
    (gen_random_uuid(), 'CBSE'),
    (gen_random_uuid(), 'ICSE'),
    (gen_random_uuid(), 'State Board')
ON CONFLICT (name) DO NOTHING;

-- Get board IDs for reference
DO $$
DECLARE
    cbse_id UUID;
    icse_id UUID;
    state_id UUID;
BEGIN
    SELECT id INTO cbse_id FROM boards WHERE name = 'CBSE';
    SELECT id INTO icse_id FROM boards WHERE name = 'ICSE';
    SELECT id INTO state_id FROM boards WHERE name = 'State Board';
    
    -- Insert classes for CBSE (5-10)
    INSERT INTO classes (board_id, class_number) VALUES 
        (cbse_id, 5), (cbse_id, 6), (cbse_id, 7), (cbse_id, 8), (cbse_id, 9), (cbse_id, 10)
    ON CONFLICT (board_id, class_number) DO NOTHING;
    
    -- Insert classes for ICSE (5-10)
    INSERT INTO classes (board_id, class_number) VALUES 
        (icse_id, 5), (icse_id, 6), (icse_id, 7), (icse_id, 8), (icse_id, 9), (icse_id, 10)
    ON CONFLICT (board_id, class_number) DO NOTHING;
    
    -- Insert classes for State Board (5-10)
    INSERT INTO classes (board_id, class_number) VALUES 
        (state_id, 5), (state_id, 6), (state_id, 7), (state_id, 8), (state_id, 9), (state_id, 10)
    ON CONFLICT (board_id, class_number) DO NOTHING;
END $$;

-- Insert subjects for Class 9 CBSE (example)
DO $$
DECLARE
    class_9_cbse_id UUID;
BEGIN
    SELECT c.id INTO class_9_cbse_id 
    FROM classes c 
    JOIN boards b ON c.board_id = b.id 
    WHERE b.name = 'CBSE' AND c.class_number = 9;
    
    INSERT INTO subjects (class_id, name) VALUES 
        (class_9_cbse_id, 'Mathematics'),
        (class_9_cbse_id, 'Physics'),
        (class_9_cbse_id, 'Chemistry'),
        (class_9_cbse_id, 'Biology'),
        (class_9_cbse_id, 'History'),
        (class_9_cbse_id, 'Geography'),
        (class_9_cbse_id, 'English'),
        (class_9_cbse_id, 'Hindi')
    ON CONFLICT DO NOTHING;
END $$;

-- Insert sample chapters for Physics Class 9 CBSE
DO $$
DECLARE
    physics_class_9_id UUID;
BEGIN
    SELECT s.id INTO physics_class_9_id 
    FROM subjects s 
    JOIN classes c ON s.class_id = c.id 
    JOIN boards b ON c.board_id = b.id 
    WHERE b.name = 'CBSE' AND c.class_number = 9 AND s.name = 'Physics';
    
    INSERT INTO chapters (subject_id, name, chapter_number) VALUES 
        (physics_class_9_id, 'Motion', 1),
        (physics_class_9_id, 'Force and Laws of Motion', 2),
        (physics_class_9_id, 'Gravitation', 3),
        (physics_class_9_id, 'Work and Energy', 4),
        (physics_class_9_id, 'Sound', 5)
    ON CONFLICT (subject_id, chapter_number) DO NOTHING;
END $$;

-- Insert sample chapters for Mathematics Class 9 CBSE
DO $$
DECLARE
    math_class_9_id UUID;
BEGIN
    SELECT s.id INTO math_class_9_id 
    FROM subjects s 
    JOIN classes c ON s.class_id = c.id 
    JOIN boards b ON c.board_id = b.id 
    WHERE b.name = 'CBSE' AND c.class_number = 9 AND s.name = 'Mathematics';
    
    INSERT INTO chapters (subject_id, name, chapter_number) VALUES 
        (math_class_9_id, 'Number Systems', 1),
        (math_class_9_id, 'Polynomials', 2),
        (math_class_9_id, 'Coordinate Geometry', 3),
        (math_class_9_id, 'Linear Equations in Two Variables', 4),
        (math_class_9_id, 'Introduction to Euclid Geometry', 5)
    ON CONFLICT (subject_id, chapter_number) DO NOTHING;
END $$;
