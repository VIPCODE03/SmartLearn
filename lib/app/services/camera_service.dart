import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AppCameraService {
  late CameraController _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  CameraController get controller => _controller;
  bool get isCameraInitialized => _isCameraInitialized;
  bool get isFlashOn => _isFlashOn;

  // 🔧 Khởi tạo camera  ----------------------------------------------
  Future<void> initializeCamera({int cameraIndex = 0}) async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![cameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller.initialize();
      _controller.setFocusMode(FocusMode.auto);
      _isCameraInitialized = true;
    }
  }

  // 🔄 Đổi camera trước/sau ---------------------------------------------
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentIndex = _cameras!.indexOf(_controller.description);
    final newIndex = (currentIndex + 1) % _cameras!.length;

    await _controller.dispose();
    _controller = CameraController(
      _cameras![newIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller.initialize();
  }

  // 📸 Chụp ảnh -------------------------------------------------------
  Future<XFile?> captureImage() async {
    if (!_controller.value.isInitialized) return null;
    return await _controller.takePicture();
  }

  // 🔦 Bật / tắt flash  -----------------------------------------------
  Future<void> toggleFlash() async {
    if (!_controller.value.isInitialized) return;

    _isFlashOn = !_isFlashOn;
    await _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  // 📂 Chọn ảnh từ gallery  -------------------------------------------
  Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<Uint8List?> pickImageBytesFromGallery() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      return await file.readAsBytes();
    }

    return null;
  }


  Future<CroppedFile?> crop(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 2),
      compressQuality: 50,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          lockAspectRatio: false,
          cropFrameStrokeWidth: 1,
          showCropGrid: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
  }

  // 🧹 Hủy controller ------------------------------------------------
  Future<void> dispose() async {
    await _controller.dispose();
  }
}