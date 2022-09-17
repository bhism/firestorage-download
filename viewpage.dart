import 'dart:io';

import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  var path;
  ViewPage({required this.path});

  @override
  State<ViewPage> createState() => _ViewPageState(path: path);
}

class _ViewPageState extends State<ViewPage> {
  var path;
  _ViewPageState({required this.path});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          path,
          width: 500,
          height: 800,
        ),
      ),
    );
  }
}
