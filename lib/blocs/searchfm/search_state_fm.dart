part of 'search_bloc_fm.dart';

class SearchStateFM extends Equatable {
  final bool displayManualMarkerFM;
  final List<Feature> placesFM;
  final List<Feature> historyFM;

  const SearchStateFM({
    this.displayManualMarkerFM = false,
    this.placesFM = const [],
    this.historyFM = const [],
  });

  SearchStateFM copyWith({
    bool? displayManualMarkerFM,
    List<Feature>? placesFM,
    List<Feature>? historyFM,
  }) =>
      SearchStateFM(
        displayManualMarkerFM: displayManualMarkerFM ?? this.displayManualMarkerFM,
        placesFM: placesFM ?? this.placesFM,
        historyFM: historyFM ?? this.historyFM,
      );

  @override
  List<Object> get props => [
        displayManualMarkerFM,
        placesFM,
        historyFM,
      ];
}
