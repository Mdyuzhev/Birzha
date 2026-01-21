-- Направления
INSERT INTO tech_directions (code, name, icon, color, sort_order) VALUES
('BACKEND', 'Backend', 'server', '#3498db', 1),
('FRONTEND', 'Frontend', 'monitor', '#e74c3c', 2),
('MOBILE', 'Mobile', 'smartphone', '#9b59b6', 3),
('DEVOPS', 'DevOps', 'cloud', '#1abc9c', 4),
('DATA', 'Data & Analytics', 'database', '#f39c12', 5),
('QA', 'QA', 'check-circle', '#2ecc71', 6),
('MANAGEMENT', 'Management', 'users', '#34495e', 7);

-- Backend стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'JAVA', 'Java', '["Spring Boot","Hibernate","Kafka"]', 1),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'PYTHON', 'Python', '["Django","FastAPI","Celery"]', 2),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'DOTNET', '.NET', '["ASP.NET Core","Entity Framework"]', 3),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'GO', 'Go', '["Gin","GORM","gRPC"]', 4),
((SELECT id FROM tech_directions WHERE code='BACKEND'), 'NODEJS', 'Node.js', '["Express","NestJS","TypeORM"]', 5);

-- Frontend стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'REACT', 'React', '["Redux","Next.js","TypeScript"]', 1),
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'VUE', 'Vue.js', '["Vuex","Pinia","Nuxt.js"]', 2),
((SELECT id FROM tech_directions WHERE code='FRONTEND'), 'ANGULAR', 'Angular', '["RxJS","NgRx","TypeScript"]', 3);

-- Mobile стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'IOS', 'iOS', '["Swift","UIKit","SwiftUI"]', 1),
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'ANDROID', 'Android', '["Kotlin","Jetpack Compose"]', 2),
((SELECT id FROM tech_directions WHERE code='MOBILE'), 'FLUTTER', 'Flutter', '["Dart","BLoC"]', 3);

-- DevOps стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'KUBERNETES', 'Kubernetes', '["Helm","ArgoCD","Istio"]', 1),
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'AWS', 'AWS', '["EC2","EKS","Lambda","S3"]', 2),
((SELECT id FROM tech_directions WHERE code='DEVOPS'), 'CICD', 'CI/CD', '["GitLab CI","Jenkins","GitHub Actions"]', 3);

-- Data стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='DATA'), 'DATA_ENGINEERING', 'Data Engineering', '["Spark","Airflow","Kafka"]', 1),
((SELECT id FROM tech_directions WHERE code='DATA'), 'DATA_SCIENCE', 'Data Science', '["Python","TensorFlow","PyTorch"]', 2),
((SELECT id FROM tech_directions WHERE code='DATA'), 'ANALYTICS', 'Analytics', '["SQL","Tableau","Power BI"]', 3);

-- QA стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='QA'), 'QA_MANUAL', 'Manual QA', '["Jira","TestRail","Postman"]', 1),
((SELECT id FROM tech_directions WHERE code='QA'), 'QA_AUTO', 'Automation QA', '["Selenium","Cypress","Playwright"]', 2);

-- Management стеки
INSERT INTO tech_stacks (direction_id, code, name, technologies, sort_order) VALUES
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'PM', 'Project Management', '["Jira","MS Project","Agile"]', 1),
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'PRODUCT', 'Product Management', '["Miro","Figma","Analytics"]', 2),
((SELECT id FROM tech_directions WHERE code='MANAGEMENT'), 'TEAMLEAD', 'Team Lead', '["1-on-1","Code Review","Mentoring"]', 3);
