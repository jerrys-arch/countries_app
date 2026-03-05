import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/country_cubit.dart';
import '../../logic/cubits/country_state.dart';
import '../../logic/cubits/favorites_cubit.dart';
import '../../logic/cubits/favorites_state.dart';
import '../widgets/country_tile.dart';
import '../../logic/cubits/detail_cubit.dart';
import 'detail_screen.dart';
import '../widgets/country_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Countries",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    setState(() {}); 

                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 500), () {
                      context.read<CountryCubit>().searchCountries(query);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search for a country",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {}); 
                        context.read<CountryCubit>().searchCountries("");
                      },
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text("Sort by:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.grey[400] : Colors.grey[700])),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: const Text("Name", style: TextStyle(fontSize: 12)),
                      onPressed: () => context.read<CountryCubit>().sortCountries(byName: true),
                    ),
                    const SizedBox(width: 8),
                    ActionChip(
                      label: const Text("Population", style: TextStyle(fontSize: 12)),
                      onPressed: () => context.read<CountryCubit>().sortCountries(byName: false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryLoading) return const CountryShimmer();
          
          if (state is CountryLoaded) {
            if (state.countries.isEmpty) return const Center(child: Text("No countries found."));

            return LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 600;
                
                return RefreshIndicator(
                  onRefresh: () => context.read<CountryCubit>().getAllCountries(),
                  child: isWide 
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: state.countries.length,
                        itemBuilder: (context, index) => _buildCountryItem(state.countries[index]),
                      )
                    : ListView.builder(
                        itemCount: state.countries.length,
                        itemBuilder: (context, index) => _buildCountryItem(state.countries[index]),
                      ),
                );
              },
            );
          }
          
          if (state is CountryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, textAlign: TextAlign.center),
                  ElevatedButton(onPressed: () => context.read<CountryCubit>().getAllCountries(), child: const Text("Retry")),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCountryItem(country) {
    final bool isSearching = _searchController.text.isNotEmpty;

    String formattedPop = country.population >= 1000000
        ? '${(country.population / 1000000).toStringAsFixed(1)}M'
        : '${(country.population / 1000).toStringAsFixed(1)}K';

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        final isFav = favState.favoriteCca2Codes.contains(country.cca2);

        return CountryTile(
          country: country,
          subtitle: isSearching ? "" : "Population: $formattedPop",
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
          trailing: isSearching 
            ? const SizedBox.shrink() 
            : IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border, 
                  color: isFav ? Colors.red : null
                ),
                onPressed: () => context.read<FavoritesCubit>().toggleFavorite(country.cca2),
              ),
        );
      },
    );
  }
}