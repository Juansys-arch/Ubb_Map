import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubb/blocs/bloc.dart';
import 'package:ubb/models/models.dart';

class SearchDestinationDelegateFM extends SearchDelegate<SearchResult> {
  SearchDestinationDelegateFM() : super(searchFieldLabel: 'Buscar...');

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
    final searchBloc = BlocProvider.of<SearchBlocFM>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnowLocation!;
    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBlocFM, SearchStateFM>(
      builder: ((context, state) {
        final placesFM = state.placesFM;
        return ListView.separated(
          itemCount: placesFM.length,
          itemBuilder: (context, i) {
            final placeFM = placesFM[i];
            return ListTile(
                title: Text(placeFM.text),
                leading: const Icon(
                  Icons.place_outlined,
                  color: Colors.black,
                ),
                onTap: () {
                  final result = SearchResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(placeFM.center[1], placeFM.center[0]),
                      name: placeFM.text,
                      );

                  searchBloc.add(AddToHistoryEventFM(placeFM));

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
    final history = BlocProvider.of<SearchBlocFM>(context).state.historyFM;
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
        ...history.map((placeFM) => ListTile(
              title: Text(placeFM.text),
              leading: const Icon(
                Icons.history,
                color: Colors.black,
              ),
              onTap: () {
                final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(placeFM.center[1], placeFM.center[0]),
                  name: placeFM.text,
                );

                close(context, result);
              },
            ))
      ],
    );
  }
}
