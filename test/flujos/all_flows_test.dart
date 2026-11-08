import 'auth_flow_test.dart' as auth_test;
import 'schedule_to_map_flow_test.dart' as schedule_test;
import 'building_info_flow_test.dart' as building_test;
import 'map_search_flow_test.dart' as search_test;

void main() {
  // Ejecuta la suite completa de los 4 flujos principales
  auth_test.main();
  schedule_test.main();
  building_test.main();
  search_test.main();
}

