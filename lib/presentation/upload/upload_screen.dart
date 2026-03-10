import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/themes/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/gradient_card.dart';
import '../../data/models/patient_model.dart';
import '../../logic/prediction/prediction_bloc.dart';
import '../../logic/prediction/prediction_event.dart';
import '../../logic/prediction/prediction_state.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String _selectedGender = AppConstants.genderOptions[0];
  String _selectedLocation = AppConstants.recordingLocations[0];
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PredictionBloc, PredictionState>(
      listener: (context, state) {
        if (state is PredictionSuccess) {
          context.push(
            '/signal',
            extra: {'prediction': state.prediction, 'patient': state.patient},
          );
        } else if (state is PredictionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.darkGradient),
          child: SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.textOnDark,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Upload Heart Sound',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOnDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // File Upload Area
                          _buildFileUploadArea(),
                          const SizedBox(height: 24),

                          // Patient Information
                          Text(
                            'Patient Information',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textOnDark,
                            ),
                          ),
                          const SizedBox(height: 16),

                          CustomTextField(
                            label: 'Patient Name',
                            hint: 'Enter patient name',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Age',
                                  hint: 'Age',
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: Icons.cake_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age < 0 || age > 150) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDropdown(
                                  'Gender',
                                  _selectedGender,
                                  AppConstants.genderOptions,
                                  (value) =>
                                      setState(() => _selectedGender = value),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _buildDropdown(
                            'Recording Location',
                            _selectedLocation,
                            AppConstants.recordingLocations,
                            (value) =>
                                setState(() => _selectedLocation = value),
                          ),
                          const SizedBox(height: 32),

                          // Submit button
                          BlocBuilder<PredictionBloc, PredictionState>(
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Analyze Heart Sound',
                                isLoading: state is PredictionLoading,
                                onPressed: _onSubmit,
                                icon: Icons.psychology_rounded,
                                gradient: AppColors.accentGradient,
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Info box
                          GradientCard(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.info,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'For demo purposes, dummy data will be used. Backend integration coming soon.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textOnDarkSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedFileName != null
                ? AppColors.success.withValues(alpha: 0.5)
                : AppColors.primary.withValues(alpha: 0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          color: _selectedFileName != null
              ? AppColors.success.withValues(alpha: 0.05)
              : AppColors.primary.withValues(alpha: 0.05),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedFileName != null
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.15),
              ),
              child: Icon(
                _selectedFileName != null
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_rounded,
                color: _selectedFileName != null
                    ? AppColors.success
                    : AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            if (_selectedFileName != null) ...[
              Text(
                _selectedFileName!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to change file',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
            ] else ...[
              Text(
                'Upload Heart Sound',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to select .wav file',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textOnDarkSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surfaceDark,
              style: GoogleFonts.inter(
                color: AppColors.textOnDark,
                fontSize: 15,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textOnDarkSecondary,
              ),
              items: options.map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav', 'mp3', 'flac'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      // For demo, just set a dummy file
      setState(() {
        _selectedFilePath = '/dummy/heartbeat.wav';
        _selectedFileName = 'heartbeat_recording.wav';
      });
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Allow submission even without file for demo
      final patient = PatientModel(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender,
        recordingLocation: _selectedLocation,
        audioFilePath: _selectedFilePath,
        audioFileName: _selectedFileName ?? 'demo_recording.wav',
        recordedAt: DateTime.now(),
      );

      context.read<PredictionBloc>().add(PredictionRequested(patient));
    }
  }
}
