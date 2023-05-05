import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/not_found.jpg',
          width: 250,
          height: 250,
        ),
        Text(
          'Nada encontrado por aqui!',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
