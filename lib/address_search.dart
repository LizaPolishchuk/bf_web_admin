import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/prezentation/profile_page/search_places/places_bloc.dart';
import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate<SuggestionPlace?> {
  final PlacesBloc placesBloc;

  AddressSearch(this.placesBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 3) {
      placesBloc.searchPlaces(query, Localizations.localeOf(context).languageCode);
    }

    return StreamBuilder<List<SuggestionPlace>>(
      stream: placesBloc.suggestedPlacesFound,
      builder: (context, snapshot) => query == ''
          ? Container(
              padding: const EdgeInsets.all(16.0),
              child: const Text('Enter your address'),
            )
          : snapshot.hasData
              ? ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text((snapshot.data![index]).name),
                    onTap: () {
                      close(context, snapshot.data![index]);
                    },
                  ),
                  itemCount: snapshot.data?.length ?? 0,
                )
              : const Text('Loading...'),
    );
  }
}
