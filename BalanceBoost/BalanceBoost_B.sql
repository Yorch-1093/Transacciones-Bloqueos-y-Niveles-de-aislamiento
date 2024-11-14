-- Crear la Base de Datos
CREATE DATABASE BalanceBoost;

-- Usar la Base de Datos
USE BalanceBoost;

-- Crear tabla Usuarios
CREATE TABLE Usuarios (
  id_usuario INT IDENTITY(1,1) PRIMARY KEY,
  nombreUsuario NVARCHAR(255) NOT NULL,
  email NVARCHAR(255),
  contraseña NVARCHAR(255) NOT NULL,
  createdAt DATETIME DEFAULT GETDATE(),
  updatedAt DATETIME DEFAULT GETDATE()
);

-- Crear tabla Contenido_Educativo
CREATE TABLE Contenido_Educativo (
  id_contenido INT IDENTITY(1,1) PRIMARY KEY,
  categoria NVARCHAR(20) CHECK (categoria IN ('salud mental', 'alimentacion', 'salud fisica')) NOT NULL,
  nombre NVARCHAR(100) NOT NULL,
  id_usuario INT,
  CONSTRAINT FK_Usuario_Contenido FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Crear tabla Salud_Fisica
CREATE TABLE Salud_Fisica (
  id_salud_fisica INT IDENTITY(1,1) PRIMARY KEY,
  rutina NVARCHAR(100),
  descanso NVARCHAR(100),
  lesiones NVARCHAR(100),
  id_contenido INT,
  CONSTRAINT FK_Contenido_SaludFisica FOREIGN KEY (id_contenido) REFERENCES Contenido_Educativo(id_contenido) ON DELETE CASCADE
);

-- Crear tabla Salud_Mental
CREATE TABLE Salud_Mental (
  id_salud_mental INT IDENTITY(1,1) PRIMARY KEY,
  meditacion NVARCHAR(100),
  terapia NVARCHAR(100),
  mindfulness NVARCHAR(100),
  id_contenido INT,
  CONSTRAINT FK_Contenido_SaludMental FOREIGN KEY (id_contenido) REFERENCES Contenido_Educativo(id_contenido) ON DELETE CASCADE
);

-- Crear tabla Alimentacion
CREATE TABLE Alimentacion (
  id_alimentacion INT IDENTITY(1,1) PRIMARY KEY,
  proteinas NVARCHAR(100),
  comidas NVARCHAR(100),
  colaciones NVARCHAR(100),
  id_contenido INT,
  CONSTRAINT FK_Contenido_Alimentacion FOREIGN KEY (id_contenido) REFERENCES Contenido_Educativo(id_contenido) ON DELETE CASCADE
);

-- Crear tabla Consejos
CREATE TABLE Consejos (
  id_consejo INT IDENTITY(1,1) PRIMARY KEY,
  texto NVARCHAR(1000) NOT NULL,
  id_usuario INT,
  createdAt DATETIME DEFAULT GETDATE(),
  updatedAt DATETIME DEFAULT GETDATE(),
  CONSTRAINT FK_Usuario_Consejos FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Crear tabla Diario
CREATE TABLE Diario (
  id_diario INT IDENTITY(1,1) PRIMARY KEY,
  texto NVARCHAR(255) NOT NULL,
  id_usuario INT,
  createdAt DATETIME DEFAULT GETDATE(),
  updatedAt DATETIME DEFAULT GETDATE(),
  CONSTRAINT FK_Usuario_Diario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Crear tabla Metas
CREATE TABLE Metas (
  id_meta INT IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR(255) NOT NULL,
  fechaInicio DATE NOT NULL,
  fechaFin DATE,
  estado NVARCHAR(20) CHECK (estado IN ('por realizar', 'en progreso', 'completada', 'dada de baja')) DEFAULT 'por realizar',
  id_usuario INT,
  CONSTRAINT FK_Usuario_Metas FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Crear tabla Progreso_Metas
CREATE TABLE Progreso_Metas (
  id_progreso_meta INT IDENTITY(1,1) PRIMARY KEY,
  id_meta INT,
  progreso_porcentaje DECIMAL(5, 2),
  fecha_actualizacion DATE NOT NULL,
  comentarios NVARCHAR(255),
  CONSTRAINT FK_Meta_Progreso FOREIGN KEY (id_meta) REFERENCES Metas(id_meta) ON DELETE CASCADE
);

-- Crear tabla Recordatorios_Actividades
CREATE TABLE Recordatorios_Actividades (
  id_recordatorio INT IDENTITY(1,1) PRIMARY KEY,
  id_meta INT,
  fecha_hora DATETIME NOT NULL,
  mensaje NVARCHAR(255),
  CONSTRAINT FK_Meta_Recordatorios FOREIGN KEY (id_meta) REFERENCES Metas(id_meta) ON DELETE CASCADE
);

-- Crear tabla Baul_Comentarios
CREATE TABLE Baul_Comentarios (
  id_comentario INT IDENTITY(1,1) PRIMARY KEY,
  tipo NVARCHAR(20) CHECK (tipo IN ('contenido educativo', 'notas', 'consejos', 'otros')) NOT NULL,
  comentario NVARCHAR(MAX) NOT NULL,
  id_usuario INT,
  fecha DATE NOT NULL,
  CONSTRAINT FK_Usuario_Comentarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

SELECT id_comentario FROM Baul_Comentarios;


-- Crear tabla Reseñas_Aplicacion modificada
CREATE TABLE Reseñas_Aplicacion (
  id_reseña INT IDENTITY(1,1) PRIMARY KEY,
  calificacion INT CHECK (calificacion >= 1 AND calificacion <= 5),
  comentario NVARCHAR(MAX),
  id_usuario INT,
  fecha_reseña DATE NOT NULL,
  id_comentario INT,  
  CONSTRAINT FK_Usuario_Reseñas FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
  CONSTRAINT FK_Comentario_Reseñas FOREIGN KEY (id_comentario) REFERENCES Baul_Comentarios(id_comentario) ON DELETE NO ACTION 
);

-- Crear tabla Riesgos_Salud
CREATE TABLE Riesgos_Salud (
  id_riesgo_salud INT IDENTITY(1,1) PRIMARY KEY,
  tipo NVARCHAR(20) CHECK (tipo IN ('fisico', 'alimentacion', 'psicologico')) NOT NULL,
  id_usuario INT,
  CONSTRAINT FK_Usuario_Riesgos FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Crear tabla Riesgos_Fisicos
CREATE TABLE Riesgos_Fisicos (
  id_riesgo_fisico INT IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR(255) NOT NULL,
  id_riesgo_salud INT,
  CONSTRAINT FK_Riesgo_Fisico FOREIGN KEY (id_riesgo_salud) REFERENCES Riesgos_Salud(id_riesgo_salud) ON DELETE CASCADE
);

-- Crear tabla Riesgos_Alimentarios
CREATE TABLE Riesgos_Alimentarios (
  id_riesgo_alimentacion INT IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR(255) NOT NULL,
  id_riesgo_salud INT,
  CONSTRAINT FK_Riesgo_Alimentacion FOREIGN KEY (id_riesgo_salud) REFERENCES Riesgos_Salud(id_riesgo_salud) ON DELETE CASCADE
);

-- Crear tabla Apoyo_Psicologico
CREATE TABLE Apoyo_Psicologico (
  id_apoyo_psicologico INT IDENTITY(1,1) PRIMARY KEY,
  descripcion NVARCHAR(255) NOT NULL,
  id_riesgo_salud INT,
  CONSTRAINT FK_Apoyo_Psicologico FOREIGN KEY (id_riesgo_salud) REFERENCES Riesgos_Salud(id_riesgo_salud) ON DELETE CASCADE
);


INSERT INTO Usuarios (nombreUsuario, email, contraseña) VALUES
('juan_perez', 'juan.perez@gmail.com', 'pass123'),
('ana_gomez', 'ana.gomez@yahoo.com', 'pass456'),
('carlos_sanchez', 'carlos.sanchez@outlook.com', 'pass789'),
('laura_martinez', 'laura.martinez@empresa.com', 'pass101112'),
('maria_fernandez', 'maria.fernandez@hotmail.com','pass131415'),
('Axel Ramirez', 'axel.ramirez@email.com', 'password123'),
('Luna Martinez', 'luna.martinez@email.com', 'securepass'),
('Orion Vega', 'orion.vega@email.com', 'orion456'),
('Sofia Marquez', 'sofia.marquez@email.com', 'sofia789'),
('Dante Cruz', 'dante.cruz@email.com', 'dante321'),
('Valeria Diaz', 'valeria.diaz@email.com', 'valeria654'),
('Nico Torres', 'nico.torres@email.com', 'nico987'),
('Emilia Flores', 'emilia.flores@email.com', 'emilia147'),
('Bruno Morales', 'bruno.morales@email.com', 'bruno258'),
('Isabella Reyes', 'isabella.reyes@email.com', 'bella369');


SELECT * FROM Usuarios;

DELETE FROM Usuarios;


INSERT INTO Contenido_Educativo (categoria, nombre, id_usuario) VALUES
('salud mental', 'Ejercicio de meditación', 1),  
('alimentacion', 'Dieta balanceada', 2),         
('salud fisica', 'Rutina de ejercicios', 3),     
('salud mental', 'Terapia cognitiva', 4),         
('alimentacion', 'Plan de alimentación', 5),     
('salud fisica', 'Entrenamiento con pesas', 6),   
('salud mental', 'Mindfulness avanzado', 7),      
('alimentacion', 'Recetas vegetarianas', 8),      
('salud fisica', 'Crossfit', 9),                   
('salud mental', 'Control del estrés', 10);       
   
SELECT * FROM Contenido_Educativo;

DELETE FROM Contenido_Educativo;

INSERT INTO Salud_Fisica (rutina, descanso, lesiones, id_contenido) VALUES
('Rutina cardio', '8 horas', 'Ninguna', 1),
('Rutina fuerza', '7 horas', 'Leve en rodilla', 2),
('Entrenamiento funcional', '8 horas', 'Ninguna',3),
('HIIT', '6 horas', 'Dolor de espalda', 4),
('Yoga', '9 horas', 'Ninguna', 5),
('Entrenamiento pesas', '7 horas', 'Lesión en muñeca', 6),
('Bicicleta', '8 horas', 'Ninguna', 7),
('Natación', '7 horas', 'Ninguna', 8),
('Crossfit', '6 horas', 'Lesión en hombro', 9),
('Pilates', '8 horas', 'Ninguna', 10),
('Rutina cardio avanzada', '7 horas', 'Lesión en tobillo', 1),
('Entrenamiento en circuito', '9 horas', 'Ninguna', 2),
('Spinning', '6 horas', 'Ninguna', 3),
('Entrenamiento con kettlebells', '7 horas', 'Lesión en codo', 4),
('Rutina fuerza avanzada', '8 horas', 'Ninguna', 5),
('Correr', '8 horas', 'Lesión en rodilla', 6),
('Escalada', '7 horas', 'Ninguna', 7),
('Boxeo', '7 horas', 'Lesión en mano', 8),
('Remo', '8 horas', 'Ninguna', 9),
('Zumba', '8 horas', 'Ninguna', 0);

SELECT * FROM Salud_Fisica;

DELETE FROM Salud_Fisica;

INSERT INTO Salud_Mental (meditacion, terapia, mindfulness, id_contenido) VALUES
('Meditación guiada', 'Cognitiva conductual', 'Mindfulness básico', 1),
('Mindfulness avanzado', 'Terapia de aceptación', 'Mindfulness intermedio', 2),
('Meditación Zen', 'Terapia centrada en soluciones', 'Mindfulness avanzado', 3),
('Relajación muscular', 'Terapia narrativa', 'Mindfulness avanzado', 4),
('Respiración profunda', 'Terapia integrativa', 'Mindfulness intermedio', 5),
('Meditación trascendental', 'Terapia de juego', 'Mindfulness avanzado', 6),
('Meditación mindfulness', 'Terapia dialéctica', 'Mindfulness básico', 7),
('Visualización guiada', 'Terapia de exposición', 'Mindfulness intermedio', 8),
('Meditación enfocada en el cuerpo', 'Terapia cognitiva', 'Mindfulness avanzado', 9),
('Meditación con mantras', 'Terapia de aceptación', 'Mindfulness básico', 10),
('Mindfulness para estrés', 'Terapia de juego', 'Mindfulness avanzado', 1),
('Respiración consciente', 'Terapia cognitiva conductual', 'Mindfulness intermedio', 2),
('Meditación en silencio', 'Terapia narrativa', 'Mindfulness avanzado', 3),
('Meditación con movimiento', 'Terapia integrativa', 'Mindfulness básico', 4),
('Meditación mindfulness avanzada', 'Terapia centrada en soluciones', 'Mindfulness avanzado', 5),
('Respiración para ansiedad', 'Terapia de juego', 'Mindfulness intermedio', 6),
('Meditación de compasión', 'Terapia de aceptación', 'Mindfulness avanzado', 7),
('Meditación guiada para principiantes', 'Terapia dialéctica', 'Mindfulness básico', 8),
('Mindfulness para dormir', 'Terapia de exposición', 'Mindfulness intermedio', 9),
('Visualización para relajación', 'Terapia cognitiva', 'Mindfulness avanzado', 10);

SELECT * FROM Salud_Mental;

DELETE FROM Salud_Mental;

INSERT INTO Alimentacion (proteinas, comidas, colaciones, id_contenido) VALUES
('Pollo', 'Comida completa', 'Frutos secos', 1),
('Tofu', 'Comida ligera', 'Yogur griego', 2),
('Pescado', 'Comida balanceada', 'Frutas', 3),
('Huevo', 'Comida baja en grasas', 'Barra de proteínas', 4),
('Legumbres', 'Comida vegetariana', 'Frutos secos', 5),
('Proteína en polvo', 'Comida deportiva', 'Batido de proteínas', 6),
('Soja', 'Comida ligera', 'Yogur con avena', 7),
('Pavo', 'Comida alta en proteínas', 'Frutas frescas', 8),
('Res', 'Comida balanceada', 'Barra energética', 9),
('Lentejas', 'Comida vegetariana', 'Yogur griego', 10),
('Atún', 'Comida completa', 'Batido de proteínas', 1),
('Garbanzos', 'Comida ligera', 'Frutos secos', 2),
('Huevos revueltos', 'Comida baja en grasas', 'Yogur natural', 3),
('Pollo a la parrilla', 'Comida alta en proteínas', 'Frutas frescas', 4),
('Proteína vegetal', 'Comida deportiva', 'Barra energética', 5),
('Carne magra', 'Comida ligera', 'Yogur con avena', 6),
('Pescado azul', 'Comida balanceada', 'Frutas frescas', 7),
('Soja texturizada', 'Comida vegetariana', 'Frutos secos', 8),
('Quinoa', 'Comida ligera', 'Barra de proteínas', 9),
('Lentejas con verduras', 'Comida completa', 'Yogur griego', 10);

SELECT * FROM Alimentacion;

DELETE FROM Alimentacion;

INSERT INTO Consejos (texto, id_usuario) VALUES
('Realiza actividad física todos los días', 1),
('Bebe suficiente agua diariamente', 2),
('Medita al menos 10 minutos al día', 3),
('Incluye más frutas y verduras en tu dieta', 4),
('Dedica tiempo a la relajación', 5),
('No te saltes el desayuno', 6),
('Haz ejercicio al aire libre', 7),
('Practica técnicas de respiración consciente', 8),
('Reduce el consumo de azúcar', 9),
('Duerme al menos 8 horas diarias', 10),
('Planifica tus comidas con anticipación', 1),
('Haz pausas activas durante el trabajo', 2),
('Establece metas de ejercicio realistas', 3),
('Evita comidas ultraprocesadas', 4),
('Practica yoga o pilates', 5),
('Evita el estrés acumulado', 6),
('Haz ejercicio en compañía de amigos', 7),
('Baja el consumo de grasas saturadas', 8),
('Utiliza aplicaciones para registrar tu progreso', 9),
('Sigue una rutina de sueño constante', 10);

SELECT * FROM Consejos;

DELETE FROM Consejos;

INSERT INTO Diario (texto, id_usuario) VALUES
('Hoy hice 30 minutos de ejercicio', 1),
('Probé una nueva receta de comida saludable', 2),
('Realicé mi sesión de meditación diaria', 3),
('Me siento más relajado después de practicar yoga', 4),
('Seguí mi plan de alimentación', 5),
('Anoté mis objetivos para la semana', 6),
('Me siento mejor mentalmente después de meditar', 7),
('Hoy aprendí una nueva técnica de respiración', 8),
('Ejercicio cardiovascular completado', 9),
('Receta saludable exitosa', 10),
('Sesión de fuerza avanzada completada', 1),
('Me sentí motivado todo el día', 2),
('Yoga por la mañana, mente despejada', 3),
('Cociné una nueva receta de dieta', 4),
('Seguí al pie de la letra mi plan de nutrición', 5),
('Pude descansar más durante la semana', 6),
('Completar una rutina de alta intensidad', 7),
('Mantuve mi energía alta durante todo el día', 8),
('Desarrollo de ejercicios funcionales', 9),
('Dieta equilibrada finalizada', 10);

SELECT * FROM Diario;

DELETE FROM Diario;

-- Insertar metas en la tabla Metas
INSERT INTO Metas (descripcion, fechaInicio, fechaFin, estado, id_usuario)
VALUES 
('Realizar 30 minutos de ejercicio físico diario', '2024-11-13', '2024-12-13', 'por realizar', 1),
('Comer 5 porciones de frutas y verduras al día', '2024-11-13', '2024-11-30', 'por realizar', 1),
('Leer 10 páginas de un libro cada día', '2024-11-13', '2024-12-31', 'por realizar', 1),
('Beber al menos 2 litros de agua al día', '2024-11-13', '2024-11-20', 'por realizar', 1),
('Dormir 8 horas por noche durante una semana', '2024-11-13', '2024-11-19', 'por realizar', 1),
('Meditar 10 minutos cada mañana', '2024-11-13', '2024-11-30', 'por realizar', 1),
('Reducir el consumo de azúcar a la mitad', '2024-11-13', '2024-11-25', 'por realizar', 1),
('Caminar al menos 5,000 pasos al día', '2024-11-13', '2024-12-13', 'por realizar', 1),
('Aprender a cocinar 5 recetas saludables', '2024-11-13', '2024-12-31', 'por realizar', 1),
('Eliminar el consumo de bebidas gaseosas durante 1 mes', '2024-11-13', '2024-12-13', 'por realizar', 1);

SELECT * FROM Metas;

DELETE FROM Metas;

-- Insertar comentarios en la tabla Baul_Comentarios
INSERT INTO Baul_Comentarios (tipo, comentario, id_usuario, fecha)
VALUES
('contenido educativo', 'Me encanta el contenido sobre salud mental, es muy útil.', 1, '2024-11-13'),
('notas', 'La función de notas es muy buena para llevar un seguimiento de mis metas diarias.', 2, '2024-11-14'),
('consejos', 'Los consejos de la aplicación me motivan a mantener una rutina saludable.', 3, '2024-11-14'),
('contenido educativo', 'Sería genial ver más videos sobre ejercicios para mejorar la flexibilidad.', 4, '2024-11-15'),
('notas', 'Las notas me permiten seguir de cerca mi progreso, me gustaría que pudieran organizarse por categorías.', 5, '2024-11-15'),
('consejos', 'Los consejos son excelentes, pero a veces son un poco generales.', 6, '2024-11-16'),
('contenido educativo', 'Me gustaría que hubiera más contenido sobre bienestar emocional y manejo de ansiedad.', 7, '2024-11-16'),
('notas', 'Sería muy útil que la aplicación tuviera recordatorios para mantenerme en la rutina diaria.', 8, '2024-11-17'),
('contenido educativo', 'El contenido sobre alimentación saludable es muy variado, me encanta.', 9, '2024-11-17'),
('consejos', 'Los consejos sobre gestión del estrés son muy buenos, pero podrían profundizar más en algunos aspectos.', 10, '2024-11-18'),
('contenido educativo', 'Me gustaría que hubiera más contenido sobre nutrición y salud mental combinado.', 11, '2024-11-18'),
('notas', 'La app podría mejorar si tuviera una opción de exportar las notas como documento.', 12, '2024-11-19'),
('contenido educativo', 'Los artículos sobre ejercicio son muy útiles, pero deberían incluir ejemplos prácticos para principiantes.', 13, '2024-11-19'),
('notas', 'Es genial poder escribir mis avances, pero a veces la app se tarda en guardar mis notas.', 14, '2024-11-20'),
('contenido educativo', 'Me encanta la sección sobre nutrición, pero sería útil agregar más recetas fáciles.', 15, '2024-11-20'),
('consejos', 'Me gustaría más consejos sobre cómo combinar una dieta saludable con el ejercicio.', 1, '2024-11-21'),
('notas', 'La opción de notas es muy útil para llevar un diario, pero algunas veces se me olvida actualizarlo.', 2, '2024-11-21'),
('contenido educativo', 'Me gustaría ver más contenido sobre psicología y técnicas para mejorar el bienestar emocional.', 3, '2024-11-22'),
('notas', 'Sería genial si pudiera agregar fotos a mis notas para hacerlas más interactivas.', 4, '2024-11-22'),
('consejos', 'A veces los consejos parecen demasiado generales, sería bueno personalizarlos más según mis hábitos.', 5, '2024-11-23');

SELECT * FROM  Baul_Comentarios;

DELETE FROM  Baul_Comentarios;

-- Insertar reseñas en la tabla Reseñas_Aplicacion
INSERT INTO Reseñas_Aplicacion (calificacion, comentario, id_usuario, fecha_reseña, id_comentario)
VALUES
(5, 'La aplicación es increíble, ha mejorado mucho mi bienestar físico y emocional. Muy recomendable.', 1, '2024-11-13', 17),
(4, 'La función de notas es muy útil para hacer seguimiento de mis hábitos, pero me gustaría que fuera más personalizada.', 2, '2024-11-14', 18),
(3, 'Los consejos de salud son buenos, aunque me gustaría más variedad y contenido específico para mi rutina.', 3, '2024-11-14', 19),
(4, 'Me encanta el contenido educativo sobre ejercicios, pero falta más sobre relajación y meditación.', 4, '2024-11-15', 20),
(5, 'Las notas son una gran ayuda para llevar un control de mis metas diarias, es una de mis funciones favoritas.', 5, '2024-11-15', 21),
(3, 'Los consejos son útiles, pero a veces siento que son demasiado generales y no tan aplicables a mi día a día.', 6, '2024-11-16', 22),
(5, 'La aplicación tiene un gran potencial. Me gustaría ver más contenido sobre bienestar emocional y manejo del estrés.', 7, '2024-11-16', 23),
(4, 'El contenido educativo es excelente, pero falta más sobre nutrición práctica y recetas fáciles.', 8, '2024-11-17', 24),
(5, 'La sección de consejos me ha ayudado a mejorar mi gestión del estrés, es uno de los puntos fuertes de la app.', 9, '2024-11-17', 25),
(4, 'Los consejos son buenos, pero me gustaría que pudieran personalizarse más según mis necesidades.', 10, '2024-11-18', 26),
(3, 'La aplicación tiene buenos recursos, pero me gustaría más integración entre el contenido educativo y las notas de progreso.', 11, '2024-11-18', 27),
(4, 'Me gustaría que la aplicación tuviera una opción para exportar las notas, sería muy práctico para mí.', 12, '2024-11-19', 28),
(5, 'Excelente contenido sobre ejercicio, pero incluir ejemplos prácticos sería genial, especialmente para principiantes.', 13, '2024-11-19', 29),
(4, 'A veces se tarda en guardar mis notas, pero en general es una herramienta muy útil para llevar el control de mis avances.', 14, '2024-11-20', 30),
(5, 'La sección de nutrición es genial, pero agregar más recetas fáciles de preparar sería aún mejor.', 15, '2024-11-20', 31),
(4, 'Sería excelente tener más consejos sobre cómo combinar dieta saludable y ejercicio para mejorar los resultados.', 1, '2024-11-21', 32),
(3, 'La opción de notas es buena, pero necesito recordatorios más frecuentes para actualizarla y hacerla más interactiva.', 2, '2024-11-21', 33),
(5, 'Me encanta el contenido educativo sobre psicología, me ayuda a mejorar mi bienestar emocional. Muy recomendable.', 3, '2024-11-22', 34),
(4, 'Me gustaría poder agregar fotos a las notas, para hacerlas más visuales y completas.', 4, '2024-11-22', 35),
(4, 'Los consejos son útiles, pero me gustaría que se personalizaran más según mis hábitos y objetivos personales.', 5, '2024-11-23', 17);

SELECT * FROM Reseñas_Aplicacion;

DELETE FROM Reseñas_Aplicacion;


-- 1. Obtener todos los usuarios y sus consejos
SELECT U.nombreUsuario, C.texto AS consejo
FROM Usuarios U
INNER JOIN Consejos C ON U.id_usuario = C.id_usuario;

-- 2. Obtener todos los usuarios con sus metas y su estado (corregido)
SELECT U.nombreUsuario, M.descripcion AS meta, M.estado
FROM Usuarios U
INNER JOIN Metas M ON U.id_usuario = M.id_usuario
WHERE M.estado IS NOT NULL;

-- 3. Contar cuántos consejos tiene cada usuario
SELECT U.nombreUsuario, COUNT(C.id_consejo) AS num_consejos
FROM Usuarios U
LEFT JOIN Consejos C ON U.id_usuario = C.id_usuario
GROUP BY U.nombreUsuario;

-- 4. Obtener los consejos relacionados con salud mental
SELECT U.nombreUsuario, C.texto AS consejo
FROM Usuarios U
INNER JOIN Consejos C ON U.id_usuario = C.id_usuario
INNER JOIN Contenido_Educativo CE ON U.id_usuario = CE.id_usuario
WHERE CE.categoria = 'salud mental';

-- 5. Obtener las metas de los usuarios que están por completar (corregido)
SELECT U.nombreUsuario, M.descripcion AS meta, M.estado
FROM Usuarios U
INNER JOIN Metas M ON U.id_usuario = M.id_usuario
WHERE M.estado = 'por realizar';

-- 6. Obtener detalles del progreso de las metas completadas (corregido)
SELECT U.nombreUsuario, M.descripcion AS meta, PM.progreso_porcentaje, PM.comentarios
FROM Usuarios U
INNER JOIN Metas M ON U.id_usuario = M.id_usuario
INNER JOIN Progreso_Metas PM ON M.id_meta = PM.id_meta
WHERE M.estado = 'completada';

-- 7. Obtener usuarios con riesgos en salud física (corregido)
SELECT U.nombreUsuario, RF.descripcion AS riesgo
FROM Usuarios U
INNER JOIN Riesgos_Fisicos RF ON U.id_usuario = RF.id_usuario;

-- 8. Obtener consejos sobre alimentación de usuarios
SELECT U.nombreUsuario, C.texto AS consejo
FROM Usuarios U
INNER JOIN Consejos C ON U.id_usuario = C.id_usuario
INNER JOIN Contenido_Educativo CE ON U.id_usuario = CE.id_usuario
WHERE CE.categoria = 'alimentacion';

-- 9. Obtener recordatorios de actividades de usuarios (corregido)
SELECT U.nombreUsuario, RA.mensaje, RA.fecha_hora
FROM Usuarios U
INNER JOIN Recordatorios_Actividades RA ON U.id_usuario = RA.id_usuario
WHERE RA.fecha_hora > GETDATE();

-- 10. Obtener comentarios en el Baúl de Comentarios en seguimiento (corregido)
SELECT U.nombreUsuario, BC.comentario, BC.estado
FROM Usuarios U
INNER JOIN Baul_Comentarios BC ON U.id_usuario = BC.id_usuario
WHERE BC.estado = 'en seguimiento';

-- 11. Obtener riesgos relacionados con la alimentación de usuarios (corregido)
SELECT U.nombreUsuario, RA.descripcion AS riesgo
FROM Usuarios U
INNER JOIN Riesgos_Alimentarios RA ON U.id_usuario = RA.id_usuario
WHERE RA.descripcion LIKE '%dieta no saludable%';

-- 12. Subconsulta para usuarios que han recibido al menos 5 recordatorios de actividad (corregido)
SELECT U.nombreUsuario
FROM Usuarios U
WHERE (SELECT COUNT(*) 
       FROM Recordatorios_Actividades RA 
       WHERE RA.id_usuario = U.id_usuario) >= 5;

-- 13. Obtener reseñas de la aplicación con calificación superior a 4 (corregido)
SELECT U.nombreUsuario, R.calificacion, R.comentario
FROM Usuarios U
INNER JOIN Reseñas_Aplicacion R ON U.id_usuario = R.id_usuario
WHERE R.calificacion > 4;

-- 14. Obtener consejos generados y editados en un rango de fechas (corregido)
SELECT U.nombreUsuario, C.texto, C.createdAt, C.updatedAt
FROM Usuarios U
INNER JOIN Consejos C ON U.id_usuario = C.id_usuario
WHERE (C.createdAt BETWEEN '2023-01-01' AND '2023-12-31' 
   OR C.updatedAt BETWEEN '2023-01-01' AND '2023-12-31');

-- 15. Obtener usuarios que han completado todas sus metas
SELECT U.nombreUsuario
FROM Usuarios U
WHERE NOT EXISTS (
    SELECT 1
    FROM Metas M
    WHERE M.id_usuario = U.id_usuario AND M.estado != 'completada'
);

-- 16. Subconsulta para usuarios con más de una meta en progreso (corregido)
SELECT U.nombreUsuario
FROM Usuarios U
WHERE (SELECT COUNT(*) 
       FROM Metas M 
       WHERE M.id_usuario = U.id_usuario AND M.estado = 'en progreso') > 1;

-- 17. Obtener total de metas en progreso y completadas por usuario (corregido)
SELECT U.nombreUsuario, 
       SUM(CASE WHEN M.estado = 'en progreso' THEN 1 ELSE 0 END) AS metas_en_progreso,
       SUM(CASE WHEN M.estado = 'completada' THEN 1 ELSE 0 END) AS metas_completadas
FROM Usuarios U
INNER JOIN Metas M ON U.id_usuario = M.id_usuario
GROUP BY U.nombreUsuario;

-- 18. Obtener riesgos de salud física y alimentación para usuarios sin metas activas (corregido)
SELECT U.nombreUsuario, RF.descripcion AS riesgo_fisico, RA.descripcion AS riesgo_alimenticio
FROM Usuarios U
INNER JOIN Riesgos_Fisicos RF ON U.id_usuario = RF.id_usuario
INNER JOIN Riesgos_Alimentarios RA ON U.id_usuario = RA.id_usuario
WHERE NOT EXISTS (SELECT 1 FROM Metas M WHERE M.id_usuario = U.id_usuario AND M.estado != 'dada de baja');

-- 19. Obtener los usuarios que han dejado comentarios y su estado (corregido)
SELECT U.nombreUsuario, BC.comentario, BC.estado
FROM Usuarios U
INNER JOIN Baul_Comentarios BC ON U.id_usuario = BC.id_usuario;


--------------------------------------------
            ---Transacciones---
	        --Jorge Hernandez
--------------------------------------------

-- 1.- Actualizar el correo electrónico de un usuario

--Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--Inicia la TRANSACCION
BEGIN TRANSACTION;
    UPDATE Usuarios
    SET email = 'anaaaa982@gmail.com' 
    WHERE nombreUsuario = 'ana_gomez';
    
-- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transaccion
COMMIT TRANSACTION;

--Deshacer la transaccion
Rollback transaction;

SELECT * FROM Usuarios;

-- 2.- Cambiar el nombre de Ususario

-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia TRANSACCION
BEGIN TRANSACTION;
    -- Cambiar el nombre de usuario
    UPDATE Usuarios 
    SET nombreUsuario = 'ana_magallon' 
    WHERE id_usuario = 2;

-- Ver bloqueos activos
	EXEC sp_lock;

-- Confirmar la transaccion
	COMMIT TRANSACTION;

--Deshacer la transaccion
	Rollback transaction;

SELECT * FROM Usuarios;



-- 3.- Registrar una nueva Meta

-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia TRANSACCION
BEGIN TRANSACTION;
    -- Insertar una nueva meta
     INSERT INTO Metas (descripcion, fechaInicio, fechaFin, estado, id_usuario)
    VALUES ('Completar 2 km de caminata diaria', '2024-11-13', '2024-11-20', 'completada', 5);

-- Ver bloqueos activos
	EXEC sp_lock;

-- Confirmar la transaccion
	COMMIT TRANSACTION;

--Deshacer la transaccion
	Rollback transaction;

SELECT * FROM Metas;



-- 4.- Crear un nuevo Consejo

--Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Inicia TRANSACCION
BEGIN TRANSACTION;
    -- Insertar un nuevo consejo
    INSERT INTO Consejos (texto, id_usuario)
    VALUES ('Come al menos 2 frutas diario', 6);

-- Ver bloqueos activos
	EXEC sp_lock;

-- Confirmar la transaccion
	COMMIT TRANSACTION;

--Deshacer la transaccion
	Rollback transaction;

SELECT * FROM Consejos;


-- 5.- Registrar una nueva Resena en la Aplicacion

--Nivel de Aislamiento Serializable
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia TRANSACCION
BEGIN TRANSACTION;

-- Insertar una reseña con bloqueo exclusivo
       INSERT INTO Reseñas_Aplicacion (calificacion, comentario, id_usuario, fecha_reseña, id_comentario)
       VALUES (5, 'Excelente aplicación para mejorar hábitos saludables', 1, GETDATE(), 30);

-- Ver bloqueos activos
	EXEC sp_lock;

-- Confirmar la transaccion
	COMMIT TRANSACTION;

--Deshacer la transaccion
	Rollback transaction;

SELECT * FROM Reseñas_Aplicacion;

-----------------------------
--Jose Alberto Avalos Alvarez
-----------------------------

--6. Insertar un registro en la tabla Salud_Mental
-- Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia TRANSACCIÓN
BEGIN TRANSACTION;
    -- Insertar un nuevo registro en la tabla Salud_Mental
    INSERT INTO Salud_Mental (meditacion, terapia, mindfulness, id_contenido)
    VALUES ('Meditación Guiada', 'Terapia Cognitivo-Conductual', 'Práctica diaria de mindfulness', 3);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

-- Verificar cambios
SELECT * FROM Salud_Mental;

--7. Insertar un registro en la tabla Contenido_Educativo
-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia TRANSACCIÓN
BEGIN TRANSACTION;
    -- Insertar un nuevo registro en la tabla Contenido_Educativo
    INSERT INTO Contenido_Educativo (categoria, nombre, id_usuario)
    VALUES ('salud mental', 'Guía de Mindfulness para Principiantes', 4);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

-- Verificar cambios
SELECT * FROM Contenido_Educativo;

--8. Insertar un registro en la tabla Alimentacion

-- Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia TRANSACCIÓN
BEGIN TRANSACTION;
    -- Insertar un nuevo registro en la tabla Alimentacion
    INSERT INTO Alimentacion (proteinas, comidas, colaciones, id_contenido)
    VALUES ('Pollo a la parrilla, huevos, tofu', 'Ensalada de quinoa y pollo', 'Frutos secos y yogurt griego', 2);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

-- Verificar cambios
SELECT * FROM Alimentacion

--9. Insertar un registro en la tabla Apoyo_Psicologico

-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia TRANSACCIÓN
BEGIN TRANSACTION;
    -- Insertar un nuevo registro en la tabla Apoyo_Psicologico
    INSERT INTO Apoyo_Psicologico (descripcion, id_riesgo_salud)
    VALUES ('Terapia para manejo de ansiedad por estrés laboral', 5);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

-- Verificar cambios
SELECT * FROM Apoyo_Psicologico;

--10. Insertar un registro en la tabla Riesgos_Alimentarios

-- Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia TRANSACCIÓN
BEGIN TRANSACTION;
    -- Insertar un nuevo registro en la tabla Riesgos_Alimentarios
    INSERT INTO Riesgos_Alimentarios (descripcion, id_riesgo_salud)
    VALUES ('Riesgo de desnutrición debido a dieta baja en calorías', 3);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

-- Verificar cambios
SELECT * FROM Riesgos_Alimentarios;



--------------------------------------------
 -- YATZIRI GARCÍA SANCHEZ
--------------------------------------------
--11. Actualizar un comentario en la tabla Baul_Comentarios
---- Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia la TRANSACCION
BEGIN TRANSACTION;

    -- Actualizar un comentario en la tabla Baul_Comentarios
    UPDATE Baul_Comentarios
    SET comentario = 'Nuevo comentario sobre consejos educativos'
    WHERE id_comentario = 1 AND id_usuario = 2;

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

SELECT * FROM Baul_Comentarios;

--12. Registrar un progreso en la tabla Progreso_Metas

-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia la TRANSACCION
BEGIN TRANSACTION;

    -- Insertar un nuevo progreso para una meta en la tabla Progreso_Metas
    INSERT INTO Progreso_Metas (id_meta, progreso_porcentaje, fecha_actualizacion, comentarios)
    VALUES (3, 50.00, '2024-11-13', 'Progreso a la mitad, se sigue trabajando');

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

SELECT * FROM Progreso_Metas;

--13. Crear una nueva entrada en la tabla Diario
-- Nivel de Aislamiento SERIALIZABLE
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Inicia la TRANSACCION
BEGIN TRANSACTION;

    -- Insertar una nueva entrada en el Diario
    INSERT INTO Diario (texto, id_usuario)
    VALUES ('Hoy ha sido un día productivo, completé mis metas de ejercicio.', 5);

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

SELECT * FROM Diario;

--14. Eliminar un comentario de la tabla Baul_Comentarios
-- Nivel de Aislamiento READ COMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Inicia la TRANSACCION
BEGIN TRANSACTION;

    -- Eliminar un comentario de la tabla Baul_Comentarios
    DELETE FROM Baul_Comentarios
    WHERE id_comentario = 2 AND id_usuario = 1;

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción
ROLLBACK TRANSACTION;

SELECT * FROM Baul_Comentarios;

--15. Actualizar el progreso de una meta e insertar un nuevo progreso en la tabla Progreso_Metas

-- Nivel de Aislamiento REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Inicia la TRANSACCION
BEGIN TRANSACTION;

    -- Actualizar el progreso de una meta existente
    UPDATE Progreso_Metas
    SET progreso_porcentaje = 80.00, comentarios = 'Avance excelente, casi al final.'
    WHERE id_progreso_meta = 2 AND id_meta = 3;

    -- Insertar un nuevo progreso para otra meta
    INSERT INTO Progreso_Metas (id_meta, progreso_porcentaje, fecha_actualizacion, comentarios)
    VALUES (4, 45.00, '2024-11-14', 'Progreso intermedio, manteniendo ritmo adecuado.');

    -- Ver bloqueos activos
    EXEC sp_lock;

-- Confirmar la transacción
COMMIT TRANSACTION;

-- Deshacer la transacción 
ROLLBACK TRANSACTION;

SELECT * FROM Progreso_Metas;












