import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String message;

  const Loading({Key? key, this.message = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 10),
        Text(message != '' ? message : 'carregando...'),
      ],
    );
  }
}
