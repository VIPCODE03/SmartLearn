import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/services/camera_service.dart';
import 'package:smart_learn/ui/dialogs/scale_dialog.dart';

import 'c_instruction_ai_screen.dart';

class SCRAICamera extends StatefulWidget {
  const SCRAICamera({super.key});

  @override
  State createState() => _SCRAICameraState();
}

class _SCRAICameraState extends State<SCRAICamera> {
  final CameraService _cameraService = CameraService();
  late String _filePath;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();
    setState(() {});
  }

  // 📂 Chọn ảnh từ thư viện ----------------------------------------------------
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _cameraService.pickImageFromGallery();
    if (pickedFile != null) await _crop(pickedFile.path);
  }

  // 🔦 Bật/tắt flash  ---------------------------------------------------------
  Future<void> _toggleFlash() async {
      await _cameraService.toggleFlash();
      setState(() {
        _cameraService.isFlashOn;
      });
    }

  //  📸 Chụp ảnh  --------------------------------------------------------------
  Future<void> _captureImage() async {
    final XFile? imageFile = await _cameraService.captureImage();
    if (imageFile != null) await _crop(imageFile.path);
  }

  //  Xử lý ảnh ----------------------------------------------------------------
  Future<void> _crop(String path) async {
    _filePath = path;
    _croppedFile = await _cameraService.crop(path);
  }

  void _next(BuildContext context) async {
    if(_croppedFile != null) {
      final file = File(_croppedFile!.path);
      final imageBytes = await file.readAsBytes();
      if(context.mounted) {
        navigateToNextScreen(
            context,
            SCRAIInstruction(
                textQuestion: '',
                image: imageBytes),
            offsetBegin: const Offset(0, 0),
            onScreenPop: (pop) async {
              await _crop(_filePath);
              if (context.mounted && _croppedFile != null) {
                _next(context);
              }
            }
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WdgScaleDialog(
          child: Text(
            "📷 Chụp ảnh: Nhấn vào nút camera để chụp ảnh.\n"
            "📂 Chọn ảnh: Nhấn vào nút thư viện để chọn ảnh từ album.\n"
            "🔦 Bật/tắt flash: Nhấn vào biểu tượng đèn để điều chỉnh đèn flash.\n"
            "❓ Trợ giúp: Nhấn vào đây để xem hướng dẫn sử dụng.",
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cameraService.isCameraInitialized
              ? CameraPreview(_cameraService.controller)
              : const Center(child: CircularProgressIndicator()),

          // ❓ Icon "?" ở góc phải
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: InkWell(
                onTap: _showHelpDialog,
                child: const Icon(Icons.help_outline,
                    size: 30, color: Colors.white),
              ),
            ),
          ),

          /// Nút -----------------------------------------------------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// 📂 Nút chọn ảnh từ thư viện  ------------------------------------
                  InkWell(
                      onTap: () async {
                        await _pickImageFromGallery();
                        if (context.mounted) {
                          _next(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withAlpha(100)),
                        child: const Icon(Icons.photo_library,
                            color: Colors.pink, size: 25),
                      )),

                  /// 📸 Nút chụp ảnh  ---------------------------------------------
                  FloatingActionButton(
                    onPressed: () async {
                      await _captureImage();
                      if (context.mounted) {
                        _next(context);
                      }
                    },
                    child: const Icon(Icons.camera, size: 35),
                  ),

                  /// 🔦 Nút bật/tắt flash --------------------------------------------
                  InkWell(
                    onTap: _toggleFlash,
                    child: Icon(
                      _cameraService.isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: _cameraService.isFlashOn ? Colors.yellow : Colors.grey,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
