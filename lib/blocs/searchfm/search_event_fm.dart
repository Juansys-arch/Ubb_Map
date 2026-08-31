part of 'search_bloc_fm.dart';

class SearchEventFM extends Equatable {
  const SearchEventFM();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEventFM extends SearchEventFM {}

class OnDeactivateManualMarkerEventFM extends SearchEventFM {}

class OnNewPlacesFoundEventFM extends SearchEventFM {
  final List<Feature> placesFM;
  const OnNewPlacesFoundEventFM(this.placesFM);
}

class AddToHistoryEventFM extends SearchEventFM {
  final Feature placeFM;
  const AddToHistoryEventFM(this.placeFM);
}
