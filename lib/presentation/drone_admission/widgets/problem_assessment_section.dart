// lib/presentation/drone_admission/widgets/problem_assessment_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../core/app_export.dart';

class ProblemAssessmentSection extends StatefulWidget {
  final TextEditingController problemDescriptionController;
  final List<String> capturedPhotos;
  final Function(List<String>) onPhotosChanged;
  final VoidCallback onCapturePhoto;

  const ProblemAssessmentSection({
    super.key,
    required this.problemDescriptionController,
    required this.capturedPhotos,
    required this.onPhotosChanged,
    required this.onCapturePhoto,
  });

  @override
  State<ProblemAssessmentSection> createState() =>
      _ProblemAssessmentSectionState();
}

class _ProblemAssessmentSectionState extends State<ProblemAssessmentSection> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _speechListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) return;
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: "en_US",
      cancelOnError: true,
    );
    setState(() => _speechListening = true);
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _speechListening = false);
  }

  void _onSpeechResult(result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult && _lastWords.isNotEmpty) {
        final current = widget.problemDescriptionController.text;
        final newText = current.isEmpty ? _lastWords : '$current $_lastWords';
        widget.problemDescriptionController.text = newText;
        widget.problemDescriptionController.selection =
            TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
        _lastWords = '';
      }
    });
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              CustomIconWidget(
                  iconName: 'bug_report',
                  color: theme.colorScheme.primary,
                  size: 28),
              SizedBox(width: 3.w),
              Text('Problem Assessment',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4.h),

          // Problem Description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Problem Description *',
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              if (_speechEnabled)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _speechListening ? _stopListening() : _startListening();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: _speechListening
                          ? theme.colorScheme.error.withOpacity(0.1)
                          : theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _speechListening
                            ? Colors.red
                            : theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_speechListening ? Icons.mic : Icons.mic_none,
                            color: _speechListening
                                ? Colors.red
                                : theme.colorScheme.primary,
                            size: 20),
                        SizedBox(width: 2.w),
                        Text(
                          _speechListening ? "Listening..." : "Voice Input",
                          style: TextStyle(
                            color: _speechListening
                                ? Colors.red
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.5.h),

          TextFormField(
            controller: widget.problemDescriptionController,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText:
                  'Describe the issue in detail... (e.g. "Drone crashed, gimbal broken, no video feed")',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              contentPadding: EdgeInsets.all(4.w),
            ),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Required'
                : v.trim().length < 10
                    ? 'Please describe in detail'
                    : null,
          ),

          if (_speechListening && _lastWords.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3)),
              ),
              child: Text('Heard: $_lastWords',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.primary)),
            ),
          ],

          SizedBox(height: 5.h),

          // Photo Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Damage Photos',
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onCapturePhoto();
                },
                icon: Icon(Icons.camera_alt, size: 20),
                label: Text("Add Photo"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          widget.capturedPhotos.isEmpty
              ? Container(
                  height: 20.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.5),
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera,
                          size: 48, color: Colors.grey[400]),
                      SizedBox(height: 2.h),
                      Text("No photos yet",
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey[600])),
                      Text("Tap 'Add Photo' to document damage",
                          style: TextStyle(
                              fontSize: 11.sp, color: Colors.grey[500])),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 3.w,
                    mainAxisSpacing: 3.w,
                  ),
                  itemCount: widget.capturedPhotos.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: theme.colorScheme.outline),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                              imageUrl: widget.capturedPhotos[i],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              final updated =
                                  List<String>.from(widget.capturedPhotos)
                                    ..removeAt(i);
                              widget.onPhotosChanged(updated);
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
