-- Таблица оценок 9-boxes
CREATE TABLE nine_box_assessments (
    id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    assessed_by BIGINT NOT NULL REFERENCES users(id),
    assessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- 5 вопросов (баллы 1-5)
    q1_results INT NOT NULL CHECK (q1_results BETWEEN 1 AND 5),
    q2_goals INT NOT NULL CHECK (q2_goals BETWEEN 1 AND 5),
    q3_quality INT NOT NULL CHECK (q3_quality BETWEEN 1 AND 5),
    q4_growth INT NOT NULL CHECK (q4_growth BETWEEN 1 AND 5),
    q5_leadership INT NOT NULL CHECK (q5_leadership BETWEEN 1 AND 5),

    -- Рассчитанные значения
    performance_score DECIMAL(3,2) NOT NULL,
    potential_score DECIMAL(3,2) NOT NULL,
    box_position INT NOT NULL CHECK (box_position BETWEEN 1 AND 9),

    comment TEXT,

    UNIQUE(employee_id)
);

CREATE INDEX idx_nine_box_employee ON nine_box_assessments(employee_id);
CREATE INDEX idx_nine_box_box_position ON nine_box_assessments(box_position);
CREATE INDEX idx_nine_box_assessed_at ON nine_box_assessments(assessed_at);
