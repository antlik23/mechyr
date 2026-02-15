import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uzis_app/auth_notifier.dart';
import 'package:uzis_app/core/constants/app_colors.dart';
import 'package:uzis_app/core/constants/app_styles.dart';
import 'package:uzis_app/core/services/voiding_service.dart';
import 'package:uzis_app/core/utils/custom_snackbar.dart';
import 'package:uzis_app/features/doctor/models/doctor_model.dart';
import 'package:uzis_app/features/doctor/services/doctor_service.dart';
import 'package:uzis_app/shared/widgets/button.dart';
import 'package:uzis_app/shared/widgets/button_outlined.dart';

class DoctorContactScreen extends StatefulWidget {
  const DoctorContactScreen({
    super.key,
    required this.doctorId,
  });

  final String doctorId;

  @override
  State<DoctorContactScreen> createState() => _DoctorContactScreenState();
}

class _DoctorContactScreenState extends State<DoctorContactScreen> {
  final DoctorService _doctorService = DoctorService();
  final VoidingService _voidingService = VoidingService();
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  DoctorModel? _doctor;
  bool _isLoadingDoctor = true;
  bool _isSubmitting = false;
  bool _agreedToShareInfo = false;
  bool _hasCompletedDiary = false;
  String _preferredContact = 'email';

  @override
  void initState() {
    super.initState();
    _loadDoctor();
    _checkVoidingDiary();
    _setDefaultMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctor() async {
    try {
      final doctor = await _doctorService.fetchDoctorDetail(
        int.parse(widget.doctorId),
      );
      setState(() {
        _doctor = doctor;
        _isLoadingDoctor = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDoctor = false;
      });
      if (mounted) {
        CustomSnackbar.showError('Chyba při načítání lékaře');
      }
    }
  }

  Future<void> _checkVoidingDiary() async {
    try {
      final latestDiary = await _voidingService.fetchLatestVoidingDiary();
      setState(() {
        _hasCompletedDiary = latestDiary?.completed ?? false;
      });
    } catch (e) {
      // Silently fail - user might not have any diary yet
      setState(() {
        _hasCompletedDiary = false;
      });
    }
  }

  void _setDefaultMessage() {
    _messageController.text = '''Dobrý den,

chtěl(a) bych Vás poprosit o vyhodnocení mého mikčního deníku a poskytnutí odborné péče.

Děkuji
''';
  }

  Future<void> _submitRequest() async {
    // Check if user already has assigned doctor
    if (mounted && context.read<AuthNotifier>().hasAssignedDoctor) {
      final doctorName = context.read<AuthNotifier>().assignedDoctorName;
      CustomSnackbar.showError(
          'Již máte přiřazeného lékaře: ${doctorName ?? 'Neznámý lékař'}');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToShareInfo) {
      CustomSnackbar.showError('Musíte souhlasit se sdílením dat s lékařem');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _doctorService.requestAssignment(
        doctorId: int.parse(widget.doctorId),
        message: _messageController.text,
        agreedToShareInfo: _agreedToShareInfo,
        phoneNumber: _phoneNumberController.text.isNotEmpty
            ? _phoneNumberController.text
            : null,
        preferredContact: _preferredContact,
      );

      if (!mounted) return;

      // Update assignment status in AuthNotifier
      if (mounted) {
        await context
            .read<AuthNotifier>()
            .setAssignmentStatus(ContactStatus.contacted);
      }

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            icon: const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.green,
            ),
            title: const Text(
              'Žádost odeslána',
              style: TextStyle(
                color: AppColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text(
              'Vaše žádost o přiřazení byla úspěšně odeslána. '
              'Lékař Vás bude kontaktovat co nejdříve.',
              style: TextStyle(
                color: AppColors.gray700,
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Zavřít',
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go('/');
                  },
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        CustomSnackbar.showError('Chyba při odesílání žádosti: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Kontaktovat lékaře',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.gray900),
      ),
      body: _isLoadingDoctor
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkBlueBase,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_doctor != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: AppStyles.borderRadius.xl,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gray400.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _doctor!.fullName ?? 'Neznámý lékař',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.blueLighter,
                                      borderRadius: AppStyles.borderRadius.lg,
                                    ),
                                    child: Text(
                                      _doctor!.specializationLabel,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.darkBlueBase,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    if (!_hasCompletedDiary) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          border: Border.all(
                            color: const Color(0xFFF59E0B),
                            width: 1,
                          ),
                          borderRadius: AppStyles.borderRadius.xl,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFF59E0B),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF78350F),
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Upozornění: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'Pro stanovení léčby je nezbytný vyplněný mikční deník – bez toho lékař nedokáže stanovit léčbu. Doporučujeme nejprve vytvořit a dokončit mikční deník.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Zpráva pro lékaře',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Napište vlastní zprávu nebo použijte předvyplněnou šablonu.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 8,
                      maxLength: 500,
                      style: AppStyles.input.text,
                      decoration: InputDecoration(
                        hintText: 'Vaše zpráva...',
                        hintStyle: AppStyles.input.hint,
                        border: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.gray100),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.gray100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.darkBlueBase),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide: const BorderSide(color: AppColors.red),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Zpráva je povinná';
                        }
                        if (value.trim().length < 10) {
                          return 'Zpráva musí mít alespoň 10 znaků';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _preferredContact == 'phone'
                          ? 'Kontaktní údaje'
                          : 'Kontaktní údaje (nepovinné)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _preferredContact == 'phone'
                          ? 'Zadejte telefonní číslo pro kontakt.'
                          : 'Pokud chcete, můžete uvést telefonní číslo a preferovaný způsob kontaktu.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: AppStyles.input.text,
                      decoration: InputDecoration(
                        labelText: 'Telefonní číslo',
                        hintText: '+420 123 456 789',
                        hintStyle: AppStyles.input.hint,
                        border: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.gray100),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.gray100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide:
                              const BorderSide(color: AppColors.darkBlueBase),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius.xl,
                          borderSide: const BorderSide(color: AppColors.red),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                      validator: (value) {
                        // If preferred contact is phone, phone number is required
                        if (_preferredContact == 'phone' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Telefonní číslo je povinné, když je vybrán kontakt telefonem';
                        }

                        // If phone number is provided, validate format
                        if (value != null && value.trim().isNotEmpty) {
                          // Remove spaces, dots, and dashes for validation
                          final cleanedNumber =
                              value.replaceAll(RegExp(r'[\s.\-]'), '');

                          // Check basic format: starts with + or 00, followed by digits
                          final phoneRegex =
                              RegExp(r'^(\+|00)?[1-9][\d]{3,14}$');

                          if (!phoneRegex.hasMatch(cleanedNumber)) {
                            return 'Zadejte platné telefonní číslo (např. +420 123 456 789)';
                          }
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Preferovaný způsob kontaktu',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'email',
                            groupValue: _preferredContact,
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _preferredContact = value ?? 'email';
                                    });
                                  },
                            activeColor: AppColors.darkBlueBase,
                            title: const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray900,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'phone',
                            groupValue: _preferredContact,
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _preferredContact = value ?? 'email';
                                    });
                                    // Revalidate form when preferred contact changes
                                    _formKey.currentState?.validate();
                                  },
                            activeColor: AppColors.darkBlueBase,
                            title: const Text(
                              'Telefon',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray900,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: AppStyles.borderRadius.lg,
                      ),
                      child: const Text(
                        'Tyto údaje slouží pouze pro usnadnění kontaktu a nebudou nikde ukládány.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.blueLighter,
                        borderRadius: AppStyles.borderRadius.xl,
                      ),
                      child: CheckboxListTile(
                        value: _agreedToShareInfo,
                        onChanged: _isSubmitting
                            ? null
                            : (value) {
                                setState(() {
                                  _agreedToShareInfo = value ?? false;
                                });
                              },
                        activeColor: AppColors.darkBlueBase,
                        checkColor: AppColors.white,
                        title: const Text(
                          'Souhlasím se sdílením mých dat s tímto lékařem',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          'Lékař bude mít přístup k vašim vyplněným dotazníkům a mikčním deníkům.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.gray700,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        text: 'Odeslat žádost',
                        onPressed: _submitRequest,
                        isLoading: _isSubmitting,
                        isDisabled: _isSubmitting,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonOutlined(
                        text: 'Zrušit',
                        onPressed: () => context.pop(),
                        isDisabled: _isSubmitting,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
