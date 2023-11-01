import 'package:flutter/material.dart';

showSnackbar(String content, BuildContext context, bool isError) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content,
        style: TextStyle(
          color: isError
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.onPrimary,
        )),
    backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
  ));
}

// showSnackBar(String content, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }