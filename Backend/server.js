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

// Conexión a MongoDB Atlas
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('>>> Conectado exitosamente a MongoDB Atlas'))
  .catch(err => console.error('>>> Error de conexion a MongoDB:', err));

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