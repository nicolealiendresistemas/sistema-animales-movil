import 'package:flutter/material.dart';
import 'package:sistema_animales/core/constants.dart';
import 'package:sistema_animales/core/routers.dart';
import 'package:sistema_animales/models/animal_model.dart';
import 'package:sistema_animales/screens/animal/animal_detail_popup.dart';
import 'package:sistema_animales/screens/rescuer/rescuer_detail_popup.dart';
import 'package:sistema_animales/servicess/animal_service.dart';
import 'package:sistema_animales/servicess/rescuer_service.dart';
import 'package:sistema_animales/widgets/animal_card.dart';
import 'package:sistema_animales/widgets/loading_indicator.dart';
import 'dart:async';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final AnimalService _animalService = AnimalService();
  late Future<List<Animal>> _futureAnimals;

  final TextEditingController _searchController = TextEditingController();
  List<Animal> _allAnimals = [];
  List<Animal> _filteredAnimals = [];
  Timer? _timer;

  @override
  @override
  void initState() {
    super.initState();
    _futureAnimals = _loadAnimals();

    _searchController.addListener(() {
      _filterAnimals(_searchController.text);
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final updatedAnimals = await _animalService.getAll();
      setState(() {
        _allAnimals = updatedAnimals;
        _filterAnimals(_searchController.text);
      });
    });
  }

  Future<List<Animal>> _loadAnimals() async {
    final animals = await _animalService.getAll();
    setState(() {
      _allAnimals = animals;
      _filteredAnimals = animals;
    });
    return animals;
  }

  void _filterAnimals(String query) {
    final filtered = _allAnimals.where((animal) {
      final name = animal.nombre.toLowerCase();
      final searchLower = query.toLowerCase();
      return name.contains(searchLower);
    }).toList();

    setState(() {
      _filteredAnimals = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/background2.jpg', fit: BoxFit.cover),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 50, left: 20, right: 20, bottom: 16),
                color: AppColors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/paw_logo.png', height: 45),
                    const Text('Lista de Animales',
                        style: AppTextStyles.heading),
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Animal>>(
                  future: _futureAnimals,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingIndicator();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (_filteredAnimals.isEmpty) {
                      return const Center(
                          child: Text('No se encontraron animales'));
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _filteredAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = _filteredAnimals[index];
                          return AnimalCard(
                            animal: animal,
                            onDetails: () {
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    AnimalDetailPopup(animal: animal),
                              );
                            },
                            onRescuer: () async {
                              final rescuerService = RescuerService();
                              try {
                                final rescatistas =
                                    await rescuerService.getAll();
                                if (rescatistas.isNotEmpty) {
                                  final rescuer = rescatistas.first;

                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        RescuerDetailPopup(rescuer: rescuer),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'No hay rescatistas disponibles')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Error al cargar rescatista: $e')),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, AppRoutes.animalForm);
          if (result == true) {
            setState(() {
              _futureAnimals = _animalService.getAll();
            });
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.folder_copy_rounded, color: Colors.white),
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.pets, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
