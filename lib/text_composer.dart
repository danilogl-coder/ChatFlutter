import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TextComposer extends StatefulWidget {
  TextComposer({super.key, required this.sendMessage});

  final Function({String text, File imgFile}) sendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  void _reset() {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(children: [
        IconButton(
            onPressed: () async {
              //Estou usando a camera com imagepicker
              final XFile? imgFile =
                  await ImagePicker().pickImage(source: ImageSource.camera);
              if (imgFile == null) return;

              //Conversão de XFile pra File
              File fileImg = File(imgFile.path);
              widget.sendMessage(imgFile: fileImg);
            },
            icon: Icon(Icons.photo_camera)),
        Expanded(
            child: TextField(
          controller: _controller,
          decoration:
              InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
          onChanged: (text) {
            setState(() {
              _isComposing = text.isNotEmpty;
            });
          },
          onSubmitted: (text) {
            widget.sendMessage(text: text);
            _reset();
          },
        )),
        IconButton(
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(text: _controller.text);
                    _reset();
                  }
                : null,
            icon: Icon(Icons.send))
      ]),
    );
  }
}
