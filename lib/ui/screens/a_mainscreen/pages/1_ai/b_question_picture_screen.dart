import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_learn/global.dart';

import 'c_instruction_ai_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  late String _filePath;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  //  Khởi tạo camera ------------------------------------------------------------
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    }
  }

  // 📂 Chọn ảnh từ thư viện ----------------------------------------------------
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _crop(pickedFile.path);
    }
  }

  // 🔦 Bật/tắt flash  ---------------------------------------------------------
  Future<void> _toggleFlash() async {
    if (_controller != null && _controller!.value.isInitialized) {
      _isFlashOn = !_isFlashOn;
      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    }
  }

  //  📸 Chụp ảnh  --------------------------------------------------------------
  Future<void> _captureImage() async {
    if (_controller != null && _controller!.value.isInitialized) {
      final XFile imageFile = await _controller!.takePicture();
      await _crop(imageFile.path);
    }
  }

  //  Xử lý ảnh ----------------------------------------------------------------
  Future<void> _crop(String path) async {
    _filePath = path;
    _croppedFile = await ImageCropper().cropImage(
      sourcePath: _filePath,
      aspectRatio: const CropAspectRatio(ratioX: 5, ratioY: 2),
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cắt ảnh',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
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

  void _next(BuildContext context) {
    navigateToNextScreen(
        context,
        InstructionAIScreen(data: _croppedFile),
        offsetBegin: const Offset(0, 0),
        onScreenPop: (pop) async {
          await _crop(_filePath);
          if(context.mounted && _croppedFile != null) {
            _next(context);
          }
        }
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hướng dẫn sử dụng"),
          content: const Text(
            "📷 Chụp ảnh: Nhấn vào nút camera để chụp ảnh.\n"
            "📂 Chọn ảnh: Nhấn vào nút thư viện để chọn ảnh từ album.\n"
            "🔦 Bật/tắt flash: Nhấn vào biểu tượng đèn để điều chỉnh đèn flash.\n"
            "❌ Đóng: Nhấn vào dấu 'X' để thoát khỏi màn hình.\n"
            "❓ Trợ giúp: Nhấn vào đây để xem hướng dẫn sử dụng.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng hộp thoại
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isCameraInitialized && _controller != null
              ? CameraPreview(_controller!)
              : const Center(child: CircularProgressIndicator()),

          // ❌ Icon "X" ở góc trái
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 16),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 30, color: Colors.white),
              ),
            ),
          ),

          // ❓ Icon "?" ở góc phải
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 16),
              child: InkWell(
                onTap: _showHelpDialog, // Mở hộp thoại hướng dẫn
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
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: _isFlashOn ? Colors.yellow : Colors.grey,
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
