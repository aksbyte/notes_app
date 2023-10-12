import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreServices fireStoreServices = FireStoreServices();
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.4),
        content: TextField(
          controller: textController,
          autocorrect: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter notes'
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              if (docID == null) {
                fireStoreServices.addNote(textController.text);
              } else {
                fireStoreServices.updateNote(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('N O T E S'),
          centerTitle: true,
          //backgroundColor: Colors.white.withOpacity(0.3),
          elevation: 1,
          backgroundColor: Colors.grey.withOpacity(0.1),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            openNoteBox();
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back.png'), fit: BoxFit.fill),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 6,
              sigmaY: 6,
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white.withOpacity(0.3),
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStoreServices.getNoteStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List notesList = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = notesList[index];
                        String docID = document.id;
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String noteText = data['note'];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: ListTile(
                            title: Text(noteText),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    openNoteBox(docID: docID);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    fireStoreServices.deleteNote(docID);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No notes available');
                  }
                },
              ),
            ),
          ),
        ));
  }
}
