import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/model/WeatherResponse.dart';

class FavouriteCitiesNotifier extends StateNotifier<List<WeatherResponse>> {
  FavouriteCitiesNotifier() : super([]);

  void toggleFavouriteStatus(WeatherResponse weather) {
    final isExisting = state.contains(weather);

    if (isExisting) {
      state = state.where((city) => city.id != weather.id).toList();
    } else {
      state = [...state, weather];
    }
  }
}

final favouriteCitiesProvider =
    StateNotifierProvider<FavouriteCitiesNotifier, List<WeatherResponse>>(
        (ref) {
  return FavouriteCitiesNotifier();
});
