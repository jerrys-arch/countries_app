import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/favorites_cubit.dart';
import '../../logic/cubits/favorites_state.dart';
import '../../logic/cubits/country_cubit.dart';
import '../../logic/cubits/country_state.dart';
import '../../logic/cubits/detail_cubit.dart';
import '../widgets/country_tile.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          if (favState.favoriteCca2Codes.isEmpty) {
            return const Center(
              child: Text("You haven't added any favorites yet."),
            );
          }

          return BlocBuilder<CountryCubit, CountryState>(
            builder: (context, countryState) {
              if (countryState is CountryLoaded) {
                final favoriteList = countryState.countries
                    .where((c) => favState.favoriteCca2Codes.contains(c.cca2))
                    .toList();

                if (favoriteList.isEmpty) {
                  return const Center(child: Text("No favorites found in current list."));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 600;

                    if (isWide) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, 
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.5, 
                        ),
                        itemCount: favoriteList.length,
                        itemBuilder: (context, index) => _buildFavoriteTile(context, favoriteList[index]),
                      );
                    }
                    return ListView.builder(
                      itemCount: favoriteList.length,
                      itemBuilder: (context, index) => _buildFavoriteTile(context, favoriteList[index]),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteTile(BuildContext context, country) {
    return CountryTile(
      country: country,
      subtitle: "Capital: ${country.capital}",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => DetailCubit()..getCountryDetails(country.cca2),
              child: const DetailScreen(),
            ),
          ),
        );
      },
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: () => context.read<FavoritesCubit>().toggleFavorite(country.cca2),
      ),
    );
  }
}