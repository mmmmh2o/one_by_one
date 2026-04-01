import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'logic/device_info_logic.dart';

/// 设备信息条目
class DeviceInfoItem {
  final String label;
  final String value;

  const DeviceInfoItem({required this.label, required this.value});
}

class DeviceInfoState {
  final List<DeviceInfoItem> items;
  final bool loading;

  const DeviceInfoState({this.items = const [], this.loading = true});

  DeviceInfoState copyWith({List<DeviceInfoItem>? items, bool? loading}) {
    return DeviceInfoState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
    );
  }
}

class DeviceInfoNotifier extends StateNotifier<DeviceInfoState> {
  DeviceInfoNotifier() : super(const DeviceInfoState()) {
    _load();
  }

  final _logic = const DeviceInfoLogic();

  Future<void> _load() async {
    try {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;
      final items = <DeviceInfoItem>[
        DeviceInfoItem(label: '品牌', value: android.brand),
        DeviceInfoItem(label: '制造商', value: android.manufacturer),
        DeviceInfoItem(label: '型号', value: android.model),
        DeviceInfoItem(label: '设备', value: android.device),
        DeviceInfoItem(label: '产品', value: android.product),
        DeviceInfoItem(label: '硬件', value: android.hardware),
        DeviceInfoItem(label: 'Board', value: android.board),
        DeviceInfoItem(label: 'Bootloader', value: android.bootloader),
        DeviceInfoItem(label: 'Android 版本',
            value: _logic.androidVersionName(android.version.sdkInt)),
        DeviceInfoItem(
            label: 'SDK 版本', value: android.version.sdkInt.toString()),
        DeviceInfoItem(label: '安全补丁', value: android.version.securityPatch ?? '未知'),
        DeviceInfoItem(
            label: 'CPU 架构',
            value: android.supportedAbis.join(', ')),
        DeviceInfoItem(label: '是否模拟器', value: android.isPhysicalDevice ? '否' : '是'),
      ];
      state = DeviceInfoState(items: items, loading: false);
    } catch (e) {
      state = DeviceInfoState(
        items: [DeviceInfoItem(label: '错误', value: '无法读取设备信息: $e')],
        loading: false,
      );
    }
  }
}

final deviceInfoProvider =
    StateNotifierProvider<DeviceInfoNotifier, DeviceInfoState>(
  (ref) => DeviceInfoNotifier(),
);
