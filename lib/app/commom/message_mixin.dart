import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MessageMixin on GetxController {
  void messageListener(Rxn<MessageModel> message) {
    ever<MessageModel?>(message, (model) async {
      if (model != null) {
        Get.snackbar(
          model.title,
          model.message,
          backgroundColor: model.type.color(),
          colorText: model.type.textColor(),
          margin: const EdgeInsets.all(20),
        );
      }
    });
  }
}

class MessageModel {
  final String message;
  final String title;
  final MessageType type;

  MessageModel({
    required this.message,
    required this.title,
    required this.type,
  });
}

enum MessageType { success, error, warning, info }

extension MessageTypeColorExt on MessageType {
  Color color() {
    switch (this) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.yellow;
      case MessageType.info:
        return Colors.blue;
    }
  }

  Color textColor() {
    switch (this) {
      case MessageType.success:
        return Colors.white;
      case MessageType.error:
        return Colors.white;
      case MessageType.warning:
        return Colors.black;
      case MessageType.info:
        return Colors.white;
    }
  }
}
