import 'package:flutter/material.dart';

class SearchView extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: InkWell(
            onTap: () {
              query = '';
            },
            child: Center(
                child: Text(
              'Clear',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.grey),
            ))),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                "Search term must be longer than two letters.",
              ),
            ),
          )
        ],
      );
    }
    return const Column();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Column();
  }
}
