import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';
import 'package:uzis_app/features/doctor/services/doctor_service.dart';
import 'package:uzis_app/features/doctor/widgets/doctor_card.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final DoctorService _doctorService = DoctorService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<DoctorModel> _doctors = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _searchQuery = '';
  Timer? _debounce;
  static const int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _refreshUserAndLoadDoctors();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _refreshUserAndLoadDoctors() async {
    // Refresh user data from API to get latest doctor assignment
    final authNotifier = context.read<AuthNotifier>();
    await authNotifier.refreshUserFromApi();

    // Then load doctors
    await _loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMore) {
        _loadMoreDoctors();
      }
    }
  }

  Future<void> _loadDoctors({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _doctors = [];
        _currentPage = 1;
        _hasMore = true;
      }
    });

    try {
      final doctors = await _doctorService.fetchAvailableDoctors(
        fullName: _searchQuery.isNotEmpty ? _searchQuery : null,
        page: _currentPage,
      );

      setState(() {
        if (refresh) {
          _doctors = doctors;
        } else {
          _doctors.addAll(doctors);
        }
        _hasMore = doctors.length >= _itemsPerPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        CustomSnackbar.showError('Chyba při načítání lékařů');
      }
    }
  }

  Future<void> _loadMoreDoctors() async {
    _currentPage++;
    await _loadDoctors();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = value;
      });
      _loadDoctors(refresh: true);
    });
  }

  Future<void> _onRefresh() async {
    // Refresh user data from API first
    final authNotifier = context.read<AuthNotifier>();
    await authNotifier.refreshUserFromApi();

    // Then refresh doctors list
    await _loadDoctors(refresh: true);
  }

  void _navigateToDetail(DoctorModel doctor) {
    context.push('/doctor-detail/${doctor.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Vyberte lékaře',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gray900),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Hledat lékaře...',
                    hintStyle: const TextStyle(color: AppColors.gray400),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.gray500),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppColors.gray500),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: AppStyles.borderRadius.xl,
                      borderSide: const BorderSide(color: AppColors.gray100),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppStyles.borderRadius.xl,
                      borderSide: const BorderSide(color: AppColors.gray100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppStyles.borderRadius.xl,
                      borderSide:
                          const BorderSide(color: AppColors.darkBlueBase),
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                  ),
                ),
                Consumer<AuthNotifier>(
                  builder: (context, authNotifier, child) {
                    final assignedDoctorId = authNotifier.assignedDoctorId;
                    final assignedDoctorName = authNotifier.assignedDoctorName;

                    if (assignedDoctorId != null &&
                        assignedDoctorName != null) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: AppStyles.borderRadius.xl,
                          border: Border.all(
                            color: const Color(0xFF86EFAC),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: AppColors.green,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Váš lékař',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF065F46),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          assignedDoctorName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF047857),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: AppColors.green,
                                size: 20,
                              ),
                              onPressed: () {
                                context
                                    .push('/doctor-detail/$assignedDoctorId');
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.darkBlueBase,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final authNotifier = context.watch<AuthNotifier>();
    final assignedDoctorId = authNotifier.assignedDoctorId;

    if (_isLoading && _doctors.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.darkBlueBase,
        ),
      );
    }

    if (_doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_search,
                size: 80,
                color: AppColors.gray400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Žádní dostupní lékaři',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Zkuste změnit vyhledávací kritéria'
                    : 'Momentálně nejsou k dispozici žádní lékaři',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _doctors.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _doctors.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: AppColors.darkBlueBase,
              ),
            ),
          );
        }

        final doctor = _doctors[index];
        final isAssigned =
            assignedDoctorId != null && doctor.id == assignedDoctorId;

        return DoctorCard(
          doctor: doctor,
          isAssigned: isAssigned,
          onTap: () => _navigateToDetail(doctor),
        );
      },
    );
  }
}
