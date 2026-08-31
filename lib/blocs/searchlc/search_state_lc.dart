part of 'search_bloc_lc.dart';

class SearchStateLC extends Equatable {
  final bool displayManualMarkerLC;
  final List<Feature> placesLC;
  final List<Feature> historyLC;

  const SearchStateLC({
    this.displayManualMarkerLC = false,
    this.placesLC = const [],
    this.historyLC = const [],
  });

  SearchStateLC copyWith({
    bool? displayManualMarkerLC,
    List<Feature>? placesLC,
    List<Feature>? historyLC,
  }) =>
      SearchStateLC(
        displayManualMarkerLC: displayManualMarkerLC ?? this.displayManualMarkerLC,
        placesLC: placesLC ?? this.placesLC,
        historyLC: historyLC ?? this.historyLC,
      );

  @override
  List<Object> get props => [
        displayManualMarkerLC,
        placesLC,
        historyLC,
      ];
}
