import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latest_project/pages/update_person_page.dart';

class ListpersonPage extends StatefulWidget {
  const ListpersonPage({Key? key, String? selectedOption}) : super(key: key);

  @override
  ListpersonPageState createState() => ListpersonPageState();
}

class ListpersonPageState extends State<ListpersonPage> {
  final Stream<QuerySnapshot> personsStream =
      FirebaseFirestore.instance.collection('persons').snapshots();

  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  Future<void> deleteUser(String id) async {
    try {
      await persons.doc(id).delete();
      debugPrint('User Deleted');
    } catch (error) {
      debugPrint('Failed to Delete user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: personsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          debugPrint('Something went wrong');
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> persons = snapshot.data!.docs;

        return ListView.builder(
          itemCount: persons.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> personData =
                persons[index].data() as Map<String, dynamic>;
            String personId = persons[index].id;
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey.withOpacity(1),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
              title: Text(
                personData['name'],
                style: const TextStyle(fontSize: 18.0),
              ),
              subtitle: Text(
                personData['email'],
                style: const TextStyle(fontSize: 16.0),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatePersonPage(
                            id: personId,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      deleteUser(
                        personId,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
// main chahta hun 