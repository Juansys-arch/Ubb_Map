const mongoose = require('mongoose');

// Esquema de Usuarios (Autenticación nativa con MongoDB)
const UserSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  password: { type: String, required: true },
  displayName: { type: String, default: '' },
  createdAt: { type: Date, default: Date.now }
});

// Esquema de Lugares (Puntos de interés en el campus)
const PlaceSchema = new mongoose.Schema({
  id: { type: String, required: true },
  text: String,
  imagen: String,
  categoria: String,
  facultad: String,
  carreras: [String],
  tramites: [String],
  faqs: [{ pregunta: String, respuesta: String }],
  placeName: [String],
  placetype: [String],
  center: [Number], // [lng, lat]
  horarios: mongoose.Schema.Types.Mixed
}, { strict: false });

// Esquema de Eventos del Campus
const EventSchema = new mongoose.Schema({
  id: { type: String },
  title: String,
  description: String,
  dateTime: String,
  category: String,
  poi_id: String,
  locationName: String,
  center: [Number]
}, { strict: false });

// Esquema de Horarios del Estudiante
const ScheduleSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  classes: [{
    day: String,
    subject: String,
    code: String,
    room: String,
    building: String,
    campus: String,
    startHour: Number,
    startMinute: Number,
    endHour: Number,
    endMinute: Number,
    color: mongoose.Schema.Types.Mixed,
    mapRoute: String
  }]
}, { strict: false });

// Esquema de Servicios del Campus (servicios_ccp)
const ServiceSchema = new mongoose.Schema({
  id: { type: String },
  title: String,
  name: String,
  description: String,
  category: String,
  locationName: String,
  location: String,
  center: [Number],
  schedule: mongoose.Schema.Types.Mixed,
  horario: mongoose.Schema.Types.Mixed
}, { strict: false });

module.exports = {
  User: mongoose.model('User', UserSchema, 'users'),
  Place: mongoose.model('Place', PlaceSchema, 'registros_ccp'),
  Event: mongoose.model('Event', EventSchema, 'eventos_ccp'),
  Schedule: mongoose.model('Schedule', ScheduleSchema, 'schedules'),
  Service: mongoose.model('Service', ServiceSchema, 'servicios_ccp')
};