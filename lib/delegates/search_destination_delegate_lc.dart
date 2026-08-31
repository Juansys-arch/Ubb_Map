import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/models/models.dart';

class SearchDestinationDelegateLC extends SearchDelegate<SearchResult> {
  SearchDestinationDelegateLC() : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          final result = SearchResult(cancel: true);
          close(context, result);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBlocLC>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnowLocation!;
    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBlocLC, SearchStateLC>(
      builder: ((context, state) {
        final placesLC = state.placesLC;
        return ListView.separated(
          itemCount: placesLC.length,
          itemBuilder: (context, i) {
            final placeLC = placesLC[i];
            return ListTile(
                title: Text(placeLC.text),
                leading: const Icon(
                  Icons.place_outlined,
                  color: Colors.black,
                ),
                onTap: () {
                  final result = SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(placeLC.center[1], placeLC.center[0]),
                      name: placeLC.text,
                      );

                  searchBloc.add(AddToHistoryEventLC(placeLC));

                  close(context, result);
                });
          },
          separatorBuilder: (context, i) => const Divider(),
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBlocLC>(context).state.historyLC;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          ),
          title: const Text(
            'Colocar la ubicación manualmente',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        ...history.map((placeLC) => ListTile(
              title: Text(placeLC.text),
              leading: const Icon(
                Icons.history,
                color: Colors.black,
              ),
              onTap: () {
                final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(placeLC.center[1], placeLC.center[0]),
                  name: placeLC.text,
                );

                close(context, result);
              },
            ))
      ],
    );
  }
}
