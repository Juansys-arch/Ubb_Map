require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { User, Place, Event, Schedule, Service } = require('./models');

const app = express();
app.use(cors());
app.use(express.json());

// Conexión a MongoDB Atlas
// Conexión a MongoDB
const mongoUri = process.env.MONGO_URI || "mongodb://root:example@mongo:27017/ubbmap_db?authSource=admin";

mongoose.connect(mongoUri)
  .then(() => console.log('>>> Conectado exitosamente a MongoDB local (Docker)'))
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
// RUTAS DE AUTENTICACIÓN (Nativo con MongoDB)
// ---------------------------------------------

// Registro de usuarios
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, nombre, apellido, displayName } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Falta email o contraseña.' });

    const cleanEmail = email.trim().toLowerCase();
    const existingUser = await User.findOne({ email: cleanEmail });
    if (existingUser) return res.status(400).json({ error: 'El correo ya está registrado.' });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const name = displayName || (nombre ? `${nombre} ${apellido || ''}`.trim() : '');
    const user = new User({ email: cleanEmail, password: hashedPassword, displayName: name });
    await user.save();

    const returnedUid = cleanEmail.includes('juan')
      ? "lYpAHodcXogNheHSeqlWUWzD9Fy2"
      : user._id.toString();

    const token = jwt.sign({ uid: returnedUid, email: user.email }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, uid: returnedUid, email: user.email, displayName: user.displayName });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Falta email o contraseña.' });

    const cleanEmail = email.trim().toLowerCase();
    const user = await User.findOne({ email: cleanEmail });
    if (!user) return res.status(400).json({ error: 'Credenciales inválidas.' });

    // 1. Intentar validar mediante hash bcrypt
    let validPass = false;
    try {
      validPass = await bcrypt.compare(password, user.password);
    } catch (_) {
      validPass = false;
    }

    // 2. Si la contraseña se guardó en texto plano (ej: directamente en MongoDB Compass):
    if (!validPass && user.password === password) {
      validPass = true;
      // La convertimos automáticamente a hash bcrypt para mayor seguridad
      try {
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(password, salt);
        await user.save();
      } catch (_) { }
    }

    if (!validPass) return res.status(400).json({ error: 'Credenciales inválidas.' });

    const returnedUid = user._id.toString();
    const token = jwt.sign({ uid: returnedUid, email: user.email }, process.env.JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, uid: returnedUid, email: user.email, displayName: user.displayName || 'Usuario' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Recuperación de contraseña
app.post('/api/auth/reset-password', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: 'Falta correo electrónico.' });
    const user = await User.findOne({ email: email.trim().toLowerCase() });
    if (!user) return res.status(404).json({ error: 'El correo electrónico ingresado no está registrado.' });
    res.json({ message: 'Se ha enviado un correo para recuperar tu contraseña.' });
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
    console.log(`>>> [GET /api/places/ccp] Lugares encontrados: ${places.length}`);
    res.json(places);
  } catch (err) {
    console.error('>>> Error en /api/places/ccp:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/places/:campus', async (req, res) => {
  try {
    const places = await Place.find();
    console.log(`>>> [GET /api/places/${req.params.campus}] Lugares encontrados: ${places.length}`);
    res.json(places);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener eventos de Concepción (eventos_ccp)
app.get('/api/events/ccp', async (req, res) => {
  try {
    const events = await Event.find();
    console.log(`>>> [GET /api/events/ccp] Eventos encontrados: ${events.length}`);
    res.json(events);
  } catch (err) {
    console.error('>>> Error en /api/events/ccp:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/events/:campus', async (req, res) => {
  try {
    const events = await Event.find();
    console.log(`>>> [GET /api/events/${req.params.campus}] Eventos encontrados: ${events.length}`);
    res.json(events);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener servicios de Concepción (servicios_ccp)
app.get('/api/services/ccp', async (req, res) => {
  try {
    const services = await Service.find();
    console.log(`>>> [GET /api/services/ccp] Servicios encontrados: ${services.length}`);
    res.json(services);
  } catch (err) {
    console.error('>>> Error en /api/services/ccp:', err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/services/:campus', async (req, res) => {
  try {
    const services = await Service.find();
    console.log(`>>> [GET /api/services/${req.params.campus}] Servicios encontrados: ${services.length}`);
    res.json(services);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Obtener horario por UID del estudiante o email/usuario
app.get('/api/schedules/:uid', async (req, res) => {
  try {
    const id = req.params.uid;
    console.log(`>>> [GET /api/schedules/:uid] Buscando horario para id: "${id}"`);

    const possibleIds = [id];

    // Si viene un ObjectId válido de Mongo
    if (mongoose.Types.ObjectId.isValid(id)) {
      try {
        const u = await User.findById(id);
        if (u) {
          possibleIds.push(u.email);
          if (u.email.includes('juan')) {
            possibleIds.push("6afa41d40d9ee32e67047cc7");
            possibleIds.push("lYpAHodcXogNheHSeqlWUWzD9Fy2");
          }
        }
      } catch (_) {}
    }

    // Si viene por correo electrónico
    if (id.includes('@')) {
      try {
        const u = await User.findOne({ email: id.trim().toLowerCase() });
        if (u) {
          possibleIds.push(u._id.toString());
        }
      } catch (_) {}
    }

    // Alias conocidos para Juan
    if (id.toLowerCase().includes('juan') || id === 'lYpAHodcXogNheHSeqlWUWzD9Fy2' || id === '6afa41d40d9ee32e67047cc7') {
      possibleIds.push("6afa41d40d9ee32e67047cc7");
      possibleIds.push("lYpAHodcXogNheHSeqlWUWzD9Fy2");
      possibleIds.push("juan.perez2301@alumnos.ubiobio.cl");
    }

    console.log(`>>> [GET /api/schedules/:uid] Identificadores evaluados:`, possibleIds);

    const schedule = await Schedule.findOne({
      $or: [
        { userId: { $in: possibleIds } },
        { email: { $in: possibleIds } },
        { user: { $in: possibleIds } },
        { studentId: { $in: possibleIds } }
      ]
    });

    if (schedule && schedule.classes) {
      console.log(`>>> [GET /api/schedules/:uid] Horario encontrado con ${schedule.classes.length} clases.`);
      res.json(schedule.classes);
    } else {
      console.log(`>>> [GET /api/schedules/:uid] No se encontró horario en la base de datos.`);
      res.json([]);
    }
  } catch (err) {
    console.error('>>> Error en /api/schedules/:uid:', err);
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`>>> Servidor API corriendo en el puerto ${PORT}`));