import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'logic/image_compress_logic.dart';

class ImageCompressState {
  final Uint8List? originalBytes;
  final Uint8List? compressedBytes;
  final int quality;
  final int maxWidth;
  final bool compressing;

  const ImageCompressState({
    this.originalBytes,
    this.compressedBytes,
    this.quality = 80,
    this.maxWidth = 0,
    this.compressing = false,
  });

  int get originalSize => originalBytes?.length ?? 0;
  int get compressedSize => compressedBytes?.length ?? 0;

  ImageCompressState copyWith({
    Uint8List? originalBytes,
    Uint8List? compressedBytes,
    int? quality,
    int? maxWidth,
    bool? compressing,
  }) {
    return ImageCompressState(
      originalBytes: originalBytes ?? this.originalBytes,
      compressedBytes: compressedBytes ?? this.compressedBytes,
      quality: quality ?? this.quality,
      maxWidth: maxWidth ?? this.maxWidth,
      compressing: compressing ?? this.compressing,
    );
  }
}

class ImageCompressNotifier extends StateNotifier<ImageCompressState> {
  ImageCompressNotifier() : super(const ImageCompressState());

  final _logic = const ImageCompressLogic();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    state = ImageCompressState(originalBytes: bytes, quality: state.quality);
    await compress();
  }

  void setQuality(int q) {
    state = state.copyWith(quality: q);
    if (state.originalBytes != null) compress();
  }

  void setMaxWidth(int w) {
    state = state.copyWith(maxWidth: w);
    if (state.originalBytes != null) compress();
  }

  Future<void> compress() async {
    if (state.originalBytes == null) return;
    state = state.copyWith(compressing: true);

    final result = _logic.compress(
      state.originalBytes!,
      quality: state.quality,
      maxWidth: state.maxWidth,
    );

    state = state.copyWith(compressedBytes: result, compressing: false);
  }

  String formatSize(int bytes) => _logic.formatSize(bytes);

  double get ratio => _logic.compressionRatio(
        state.originalSize,
        state.compressedSize,
      );
}

final imageCompressProvider =
    StateNotifierProvider<ImageCompressNotifier, ImageCompressState>(
  (ref) => ImageCompressNotifier(),
);
