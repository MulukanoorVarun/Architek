import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:arkitek_app/blocs/architect/architect_bloc.dart';
import 'package:arkitek_app/widgets/architect_card.dart';
import 'package:arkitek_app/theme/spacing.dart';
import 'package:arkitek_app/theme/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isMapView = false;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  
  // Filter state
  RangeValues _budgetRange = const RangeValues(1000, 50000);
  final List<String> _specializations = [
    'Residential',
    'Commercial',
    'Industrial',
    'Landscape',
    'Interior',
    'Renovation',
    'Sustainable',
    'Urban Planning'
  ];
  final List<String> _selectedSpecializations = [];
  int _minExperience = 0;

  @override
  void initState() {
    super.initState();
    context.read<ArchitectBloc>().add(const LoadArchitects());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Architects'),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, location, or specialty...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
              ),
              onChanged: (value) {
                // Trigger search
                if (value.length > 2) {
                  context.read<ArchitectBloc>().add(SearchArchitects(value));
                } else if (value.isEmpty) {
                  context.read<ArchitectBloc>().add(const LoadArchitects());
                }
              },
            ),
          ),
          if (_selectedSpecializations.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: Badge(
                label: Text(_selectedSpecializations.length.toString()),
                child: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showFilterBottomSheet,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return BlocBuilder<ArchitectBloc, ArchitectState>(
      builder: (context, state) {
        if (state is ArchitectsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ArchitectsLoaded) {
          return ListView.builder(
            padding: EdgeInsets.all(AppSpacing.md),
            itemCount: state.architects.length,
            itemBuilder: (context, index) {
              final architect = state.architects[index];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: ArchitectCard(
                  architect: architect,
                  onTap: () {
                    // Navigate to architect details
                  },
                  isHorizontal: true,
                ),
              );
            },
          );
        } else if (state is ArchitectsError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          // Show placeholder data
          return ListView.builder(
            padding: EdgeInsets.all(AppSpacing.md),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.secondary[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildMapView() {
    return BlocBuilder<ArchitectBloc, ArchitectState>(
      builder: (context, state) {
        if (state is ArchitectsLoaded) {
          // Create markers for each architect
          _createMarkers(state.architects);
          
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.7749, -122.4194), // Default to San Francisco
                  zoom: 12,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              // Mini list at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: state.architects.length,
                    itemBuilder: (context, index) {
                      final architect = state.architects[index];
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md),
                        child: SizedBox(
                          width: 200,
                          child: ArchitectCard(
                            architect: architect,
                            onTap: () {
                              // Navigate to architect details
                            },
                            onMapFocus: () {
                              // Center map on this architect
                              _mapController?.animateCamera(
                                CameraUpdate.newLatLng(
                                  LatLng(
                                    architect.location.coordinates.latitude,
                                    architect.location.coordinates.longitude,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _createMarkers(architects) {
    _markers.clear();
    for (final architect in architects) {
      final marker = Marker(
        markerId: MarkerId(architect.id),
        position: LatLng(
          architect.location.coordinates.latitude,
          architect.location.coordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: architect.name,
          snippet: architect.specialization.join(', '),
        ),
        onTap: () {
          // Show architect info
        },
      );
      _markers.add(marker);
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(AppSpacing.md),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Results',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSpecializations.clear();
                            _budgetRange = const RangeValues(1000, 50000);
                            _minExperience = 0;
                          });
                        },
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Specialization',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: _specializations.map((spec) {
                              final isSelected = _selectedSpecializations.contains(spec);
                              return FilterChip(
                                label: Text(spec),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedSpecializations.add(spec);
                                    } else {
                                      _selectedSpecializations.remove(spec);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Budget Range',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          RangeSlider(
                            values: _budgetRange,
                            min: 1000,
                            max: 100000,
                            divisions: 99,
                            labels: RangeLabels(
                              '\$${_budgetRange.start.round()}',
                              '\$${_budgetRange.end.round()}',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _budgetRange = values;
                              });
                            },
                          ),
                          Text(
                            'Budget: \$${_budgetRange.start.round()} - \$${_budgetRange.end.round()}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Minimum Experience (Years)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Slider(
                            value: _minExperience.toDouble(),
                            min: 0,
                            max: 20,
                            divisions: 20,
                            label: _minExperience.toString(),
                            onChanged: (value) {
                              setState(() {
                                _minExperience = value.round();
                              });
                            },
                          ),
                          Text(
                            'Experience: ${_minExperience}+ years',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ArchitectBloc>().add(
                          FilterArchitects(
                            specializations: _selectedSpecializations,
                            minBudget: _budgetRange.start,
                            maxBudget: _budgetRange.end,
                            minExperience: _minExperience,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}