part of 'search_bloc_lc.dart';

class SearchEventLC extends Equatable {
  const SearchEventLC();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEventLC extends SearchEventLC {}

class OnDeactivateManualMarkerEventLC extends SearchEventLC {}

class OnNewPlacesFoundEventLC extends SearchEventLC {
  final List<Feature> placesLC;
  const OnNewPlacesFoundEventLC(this.placesLC);
}

class AddToHistoryEventLC extends SearchEventLC {
  final Feature placeLC;
  const AddToHistoryEventLC(this.placeLC);
}
