import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BuildingFaq {
  final String question;
  final String answer;

  const BuildingFaq({
    required this.question,
    required this.answer,
  });
}

class BuildingInfo {
  final String id;
  final String name;
  final String shortName;
  final String category;
  final String description;
  final LatLng location;
  final String schedule;
  final String campus;
  final IconData icon;
  final Color iconColor;
  final List<String> services;
  final List<BuildingFaq> faqs;

  const BuildingInfo({
    required this.id,
    required this.name,
    required this.shortName,
    required this.category,
    required this.description,
    required this.location,
    required this.schedule,
    required this.campus,
    required this.icon,
    required this.iconColor,
    required this.services,
    required this.faqs,
  });
}

/// Datos iniciales con las 3 zonas solicitadas: Rectoría, DDE y Finanzas
final List<BuildingInfo> sampleBuildings = [
  const BuildingInfo(
    id: 'rectoria',
    name: 'Rectoría UBB',
    shortName: 'Rectoría',
    category: 'Administración Central',
    description:
        'Sede del gobierno universitario y administración superior de la Universidad del Bío-Bío. Aquí se ubican el despacho de Rectoría, Prorrectoría, Secretaría General y salas de reuniones de consejo.',
    location: LatLng(-36.82145, -73.01320),
    schedule: 'Lunes a Viernes: 08:30 - 17:30 hrs',
    campus: 'Concepción',
    icon: Icons.account_balance,
    iconColor: Color(0xFF1A3253),
    services: [
      'Secretaría General y firma de decretos universitarios',
      'Atención de audiencias y protocolos institucionales',
      'Gestión de convenios nacionales e internacionales',
      'Dirección Superior y gobierno universitario',
    ],
    faqs: [
      BuildingFaq(
        question: '¿Qué trámites puedo realizar en Rectoría?',
        answer:
            'En Rectoría se concentran las gestiones superiores e institucionales de la universidad y la Secretaría General. Para trámites académicos regulares (notas, certificados de notas), debes acudir a Admisión y Registro Académico (DARA).',
      ),
      BuildingFaq(
        question: '¿Dónde se encuentra exactamente?',
        answer:
            'En el corazón administrativo del Campus Concepción, próximo al Paseo Central y al Paraninfo.',
      ),
    ],
  ),
  const BuildingInfo(
    id: 'dde',
    name: 'Dirección de Desarrollo Estudiantil (DDE)',
    shortName: 'DDE',
    category: 'Bienestar y Apoyo Estudiantil',
    description:
        'Organismo encargado del acompañamiento integral del estudiante: bienestar socioeconómico, servicio médico/dental, atención psicológica, deportes y cultura.',
    location: LatLng(-36.82285, -73.01185),
    schedule: 'Lunes a Viernes: 08:30 - 17:00 hrs',
    campus: 'Concepción',
    icon: Icons.volunteer_activism,
    iconColor: Color(0xFF00897B),
    services: [
      'Bienestar Estudiantil y asignación de Asistentes Sociales',
      'Postulación y renovación de Becas JUNAEB y UBB (alimentación, residencia)',
      'Servicio Médico y Dental de Alumnos (SEMDA)',
      'Atención y orientación psicológica',
      'Apoyo a organizaciones estudiantiles y centros de alumnos',
    ],
    faqs: [
      BuildingFaq(
        question: '¿Cómo solicito hora con el médico o dentista?',
        answer:
            'Puedes solicitar tu hora presencialmente en el mesón de atención médica de la DDE o a través de los canales digitales que dispone el Servicio de Salud Estudiantil al inicio de cada jornada.',
      ),
      BuildingFaq(
        question: '¿Dónde veo a mi asistente social por becas o gratuidad?',
        answer:
            'En el departamento de Bienestar Estudiantil de la DDE. Cada carrera tiene asignada una trabajadora social para revisar antecedentes y apelaciones.',
      ),
      BuildingFaq(
        question: '¿Dónde valido o revalido mi Tarjeta TNE?',
        answer:
            'Los procesos masivos de pegado de sellos o captura fotográfica de TNE se coordinan periódicamente a través de la DDE en sus dependencias o en los accesos contiguos.',
      ),
    ],
  ),
  const BuildingInfo(
    id: 'finanzas',
    name: 'Dirección de Finanzas y Cobranzas',
    shortName: 'Finanzas',
    category: 'Aranceles y Pagos',
    description:
        'Unidad administrativa encargada de la recaudación de matrículas y aranceles, administración del Fondo Solidario de Crédito Universitario, pagarés CAE y convenios de pago.',
    location: LatLng(-36.82195, -73.01285),
    schedule: 'Lunes a Viernes: 08:30 - 16:30 hrs',
    campus: 'Concepción',
    icon: Icons.payments_outlined,
    iconColor: Color(0xFFC67D0A),
    services: [
      'Pago presencial de aranceles y cuotas de matrícula',
      'Emisión, entrega y recepción de pagarés del Fondo Solidario',
      'Gestión y validación de beneficios de Crédito con Aval del Estado (CAE)',
      'Convenios de repactación de deuda y prórrogas',
      'Emisión de certificados de deuda / no deuda arancelaria',
    ],
    faqs: [
      BuildingFaq(
        question: '¿Qué hago si tengo bloqueo financiero para inscribir asignaturas?',
        answer:
            'Debes acudir a la Dirección de Finanzas y Cobranzas para revisar tu estado de cuenta y acordar un convenio o regularización de cuotas pendientes.',
      ),
      BuildingFaq(
        question: '¿Dónde legalizo y entrego mi pagaré de Fondo Solidario o CAE?',
        answer:
            'En los módulos del Departamento de Cobranzas y Aranceles dentro del edificio de Finanzas, presentando tu cédula de identidad y documento firmado ante notario.',
      ),
      BuildingFaq(
        question: '¿Cuáles son los medios de pago disponibles?',
        answer:
            'Puedes pagar mediante Webpay / portal de pagos en línea institucional, o presencialmente en las cajas de tesorería del edificio de Finanzas con tarjeta de débito/crédito.',
      ),
    ],
  ),
];
