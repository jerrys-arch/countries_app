import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../logic/cubits/detail_cubit.dart';
import '../../logic/cubits/detail_state.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<DetailCubit, DetailState>(
          builder: (context, state) {
            if (state is DetailLoaded) {
              return Text(
                state.country.commonName,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black, 
                  fontWeight: FontWeight.bold
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailLoaded) {
            final country = state.country;

            return SingleChildScrollView(
              child: Center( 
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        child: CachedNetworkImage(
                          imageUrl: country.flagPng,
                          width: double.infinity,
                          height: 300, 
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 300, 
                            color: Colors.grey[300]
                          ),
                          errorWidget: (context, url, error) => 
                            const SizedBox(height: 300, child: Icon(Icons.flag)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Key Statistics",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            _buildStatRow(context, "Area", "${country.area.toStringAsFixed(0)} sqkm"),
                            _buildStatRow(context, "Population", "${(country.population / 1000000).toStringAsFixed(2)} million"),
                            _buildStatRow(context, "Region", country.region),
                            _buildStatRow(context, "Sub Region", country.subregion),

                            const SizedBox(height: 32),
                            Text(
                              "Timezones",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: country.timezones.map((tz) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isDarkMode ? Colors.grey[700]! : Colors.grey.shade300
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tz,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is DetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600, fontSize: 15)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ],
      ),
    );
  }
}