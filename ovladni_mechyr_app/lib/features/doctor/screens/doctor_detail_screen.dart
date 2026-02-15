import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/utils/url_launcher_helper.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';
import 'package:uzis_app/features/doctor/services/doctor_service.dart';
import 'package:uzis_app/shared/widgets/button.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({
    super.key,
    required this.doctorId,
  });

  final String doctorId;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final DoctorService _doctorService = DoctorService();
  DoctorModel? _doctor;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
  }

  Future<void> _loadDoctor() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final doctor = await _doctorService.fetchDoctorDetail(
        int.parse(widget.doctorId),
      );
      setState(() {
        _doctor = doctor;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _navigateToContact() {
    if (_doctor != null) {
      context.push('/doctor-contact/${widget.doctorId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Detail lékaře',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gray900),
      ),
      body: _buildBody(),
      bottomNavigationBar: _doctor != null && _doctor!.isContactable
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray400.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Button(
                  text: 'Kontaktovat lékaře',
                  onPressed: _navigateToContact,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.darkBlueBase,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Chyba při načítání',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: Button(
                  text: 'Zkusit znovu',
                  onPressed: _loadDoctor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_doctor == null) {
      return const Center(
        child: Text(
          'Lékař nenalezen',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.gray700,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1, color: AppColors.gray100),
          if (!_doctor!.isContactable)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.redLighter,
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.red,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tento lékař momentálně nepřijímá nové pacienty',
                      style: TextStyle(
                        color: AppColors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _buildContactSection(),
          if (_doctor!.fullAddress.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.gray100),
            _buildAddressSection(),
          ],
          if (_doctor!.workingHours != null &&
              _doctor!.workingHours!.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.gray100),
            _buildWorkingHoursSection(),
          ],
          if (_doctor!.web != null && _doctor!.web!.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.gray100),
            _buildWebSection(),
          ],
          const SizedBox(height: 88),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.blueLighter,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            _doctor!.fullName ?? 'Neznámý lékař',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.darkBlueBase,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _doctor!.specializationLabel,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (_doctor!.workplace != null && _doctor!.workplace!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _doctor!.workplace!,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kontaktní informace',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          if (_doctor!.contactEmail != null &&
              _doctor!.contactEmail!.isNotEmpty)
            _buildContactItem(
              icon: Icons.email_outlined,
              label: 'Email',
              value: _doctor!.contactEmail!,
              onTap: () => UrlLauncherHelper.launchEmail(
                context,
                _doctor!.contactEmail!,
              ),
            ),
          if (_doctor!.contactPhone != null &&
              _doctor!.contactPhone!.isNotEmpty)
            _buildContactItem(
              icon: Icons.phone_outlined,
              label: 'Telefon',
              value: _doctor!.contactPhone!,
              onTap: () => UrlLauncherHelper.launchPhone(
                context,
                _doctor!.contactPhone!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adresa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => UrlLauncherHelper.launchMaps(
              context,
              latitude: _doctor!.latitude,
              longitude: _doctor!.longitude,
              address: _doctor!.fullAddress,
            ),
            borderRadius: AppStyles.borderRadius.xl,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppStyles.borderRadius.xl,
                border: Border.all(color: AppColors.gray100),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 32,
                    color: AppColors.darkBlueBase,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_doctor!.streetAndNumber != null &&
                            _doctor!.streetAndNumber!.isNotEmpty)
                          Text(
                            _doctor!.streetAndNumber!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.gray900,
                            ),
                          ),
                        if (_doctor!.city != null && _doctor!.city!.isNotEmpty)
                          Text(
                            _doctor!.postalCode != null
                                ? '${_doctor!.postalCode} ${_doctor!.city}'
                                : _doctor!.city!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.gray900,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.gray500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ordinační hodiny',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.blueLighter,
              borderRadius: AppStyles.borderRadius.xl,
            ),
            child: Text(
              _doctor!.workingHours!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Webové stránky',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.language,
            label: 'Web',
            value: _doctor!.web!,
            onTap: () => UrlLauncherHelper.launchWebsite(
              context,
              _doctor!.web!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppStyles.borderRadius.xl,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppStyles.borderRadius.xl,
          border: Border.all(color: AppColors.gray100),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.darkBlueBase,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.gray500,
            ),
          ],
        ),
      ),
    );
  }
}
