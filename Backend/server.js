require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { User, Place, Event, Schedule } = require('./models');

const app = express();
app.use(cors());
app.use(express.json());

// Conexión a MongoDB
const mongoUri = process.env.MONGO_URI || 'mongodb://db:27017/ubbmap_db';
mongoose.connect(mongoUri)
  .then(async () => {
    console.log('>>> Conectado exitosamente a MongoDB:', mongoUri);
    await seedDefaultData();
  })
  .catch(err => console.error('>>> Error de conexion a MongoDB:', err));

async function seedDefaultData() {
  try {
    const placesCount = await Place.countDocuments();
    if (placesCount === 0) {
      console.log('>>> Poblando lugares iniciales del Campus Concepción...');
      await Place.insertMany([
        {
          id: 'rectoria',
          text: 'Rectoría UBB',
          imagen: 'https://ubiobio.cl/imagenes/rectoria.jpg',
          categoria: 'Administración',
          facultad: 'Administración Central',
          carreras: ['Dirección Superior', 'Secretaría General'],
          tramites: ['Secretaría General', 'Decretos', 'Convenios Institucionales'],
          faqs: [{ pregunta: '¿Qué trámites se realizan aquí?', respuesta: 'Gestión institucional y secretaría general.' }],
          placeName: ['Rectoría UBB', 'Rectoría'],
          placetype: ['poi'],
          center: [-73.01320, -36.82145]
        },
        {
          id: 'dde',
          text: 'Dirección de Desarrollo Estudiantil (DDE)',
          imagen: 'https://ubiobio.cl/imagenes/dde.jpg',
          categoria: 'Bienestar',
          facultad: 'Bienestar Estudiantil',
          carreras: ['Trabajo Social', 'Salud Estudiantil'],
          tramites: ['TNE / Pase Escolar', 'Becas y Créditos', 'Atención Médica y Dental', 'Apoyo Psicológico'],
          faqs: [{ pregunta: '¿Cómo revalido mi TNE?', respuesta: 'Debes presentar tu cédula y pase en las oficinas de bienestar.' }],
          placeName: ['Dirección de Desarrollo Estudiantil', 'DDE'],
          placetype: ['poi'],
          center: [-73.01410, -36.82280]
        },
        {
          id: 'finanzas',
          text: 'Departamento de Finanzas y Tesorería',
          imagen: 'https://ubiobio.cl/imagenes/finanzas.jpg',
          categoria: 'Finanzas',
          facultad: 'Administración y Finanzas',
          carreras: ['Cobranzas', 'Aranceles'],
          tramites: ['Pago de Aranceles y Matrícula', 'Convenios de Pago', 'Pagarés y Certificados de Deuda'],
          faqs: [{ pregunta: '¿Dónde puedo pagar mi arancel?', respuesta: 'En ventanilla de tesorería o vía portal online.' }],
          placeName: ['Finanzas UBB', 'Tesorería'],
          placetype: ['poi'],
          center: [-73.01250, -36.82180]
        },
        {
          id: 'biblioteca',
          text: 'Biblioteca Central UBB',
          imagen: 'https://ubiobio.cl/imagenes/biblioteca.jpg',
          categoria: 'Académico',
          facultad: 'Dirección de Bibliotecas',
          carreras: ['Préstamo de Libros', 'Salas de Estudio'],
          tramites: ['Préstamo de Bibliografía', 'Reserva de Cubículos', 'Acceso a Bases de Datos'],
          faqs: [{ pregunta: '¿Cuál es el horario de biblioteca?', respuesta: 'Lunes a Viernes de 08:30 a 20:00 hrs.' }],
          placeName: ['Biblioteca Central', 'Biblioteca'],
          placetype: ['poi'],
          center: [-73.01350, -36.82210]
        }
      ]);
      console.log('>>> Lugares iniciales poblados con éxito.');
    }

    const eventsCount = await Event.countDocuments();
    if (eventsCount === 0) {
      console.log('>>> Poblando eventos iniciales...');
      await Event.insertMany([
        {
          id: 'evento_1',
          title: 'Feria Vocacional y de Empleabilidad UBB',
          description: 'Encuentro con empresas y egresados en el Paraninfo.',
          dateTime: '2026-11-20 10:00',
          category: 'Feria',
          locationName: 'Paraninfo UBB',
          center: [-73.01300, -36.82170]
        },
        {
          id: 'evento_2',
          title: 'Torneo Interfacultades de Fútbol',
          description: 'Fase clasificatoria en las canchas del campus.',
          dateTime: '2026-11-22 15:00',
          category: 'Deportes',
          locationName: 'Canchas UBB',
          center: [-73.01450, -36.82350]
        }
      ]);
      console.log('>>> Eventos iniciales poblados con éxito.');
    }
  } catch (err) {
    console.error('>>> Error durante el seed inicial:', err);
  }
}

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'API REST UBB Map funcionando correctamente',
    database: mongoose.connection.readyState === 1 ? 'conectada' : 'desconectada',
    timestamp: new Date().toISOString()
  });
});

// Middleware de verificación de Token JWT
const authMiddleware = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Acceso denegado. Token no proporcionado.' });

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    res.status(401).json({ error: 'Token invalido o expirado.' });
  }
};

// ---------------------------------------------
// RUTAS DE AUTENTICACIÓN (Reemplazo de Firebase Auth)
// ---------------------------------------------

// Registro de usuarios
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Falta email o contraseña.' });

    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ error: 'El correo ya esta registrado.' });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = new User({ email, password: hashedPassword });
    await user.save();

    const token = jwt.sign({ uid: user._id.toString(), email: user.email }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, uid: user._id.toString(), email: user.email });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ error: 'Credenciales invalidas.' });

    const validPass = await bcrypt.compare(password, user.password);
    if (!validPass) return res.status(400).json({ error: 'Credenciales invalidas.' });

    const token = jwt.sign({ uid: user._id.toString(), email: user.email }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, uid: user._id.toString(), email: user.email });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ---------------------------------------------
// RUTAS DE DATOS (Reemplazo de Realtime Database)
// ---------------------------------------------

// Obtener lugares de Concepción (registros_ccp)
app.get('/api/places/ccp', async (req, res) => {
  try {
    const places = await Place.find();
    res.json(places);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener eventos de Concepción (eventos_ccp)
app.get('/api/events/ccp', async (req, res) => {
  try {
    const events = await Event.find();
    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener horario por UID del estudiante
app.get('/api/schedules/:uid', async (req, res) => {
  try {
    const schedule = await Schedule.findOne({ userId: req.params.uid });
    res.json(schedule ? schedule.classes : []);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`>>> Servidor API corriendo en el puerto ${PORT}`));