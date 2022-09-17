import 'dart:io';
import 'package:flutter/material.dart';

class nectpage extends StatefulWidget {
  var path;
  nectpage({required this.path});

  @override
  State<nectpage> createState() => _nectpageState(path: path);
}

class _nectpageState extends State<nectpage> {
  var path;
  _nectpageState({required this.path});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(
          File(path),
          width: 500,
          height: 800,
        ),
      ),
    );
  }
}
