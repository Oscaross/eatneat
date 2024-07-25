import 'package:flutter/material.dart';

class AddLabelPage extends StatefulWidget {

  @override
  _AddLabelPageState createState() => _AddLabelPageState();
}

class _AddLabelPageState extends State<AddLabelPage> {
  final TextEditingController _nameController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new label"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label name input
            SizedBox(
                child: TextField(
                  autocorrect: true,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText:"Label Name"
                  ),
                  keyboardType:TextInputType.text,)
                  ),
            // Label color input
          ]
        )
      )
    );
  }
}