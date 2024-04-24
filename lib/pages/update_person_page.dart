import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdatePersonPage extends StatefulWidget {
  final String id;

  const UpdatePersonPage({Key? key, required this.id}) : super(key: key);

  @override
  UpdatePersonPageState createState() => UpdatePersonPageState();
}

class UpdatePersonPageState extends State<UpdatePersonPage> {
  final formKey = GlobalKey<FormState>();

  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  Future<void> updateUser(String id, String name, String email, String password,
      String contact, String gender, DateTime? dob) {
    return persons
        .doc(id)
        .update({
          'name': name,
          'email': email,
          'password': password,
          'contact': contact,
          'gender': gender,
          'dob': dob != null ? Timestamp.fromDate(dob) : null,
        })
        .then(
          (value) => debugPrint(
            "User Updated",
          ),
        )
        .catchError(
          (error) => debugPrint(
            "Failed to update user: $error",
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Update Person",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 15.0,
            ),
            child: IconButton(
              onPressed: () {
                formKey.currentState!.reset();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Form(
        key: formKey,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection(
                'persons',
              )
              .doc(widget.id)
              .get(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              debugPrint(
                'Something went wrong',
              );
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data!.data();
            var name = data!['name'];
            var email = data['email'];
            var password = data['password'];
            var contact = data['contact'];
            var gender = data['gender'];
            var dobTimestamp = data['dob'];
            DateTime? dob;

            if (dobTimestamp != null) {
              dob = dobTimestamp.toDate();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: name,
                      autofocus: false,
                      onChanged: (value) => name = value,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextFormField(
                      initialValue: email,
                      autofocus: false,
                      onChanged: (value) => email = value,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        } else if (!value.contains('@')) {
                          return 'Please enter valid Email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: password,
                      autofocus: false,
                      onChanged: (value) => password = value,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      initialValue: contact,
                      autofocus: false,
                      onChanged: (value) => contact = value,
                      decoration: const InputDecoration(
                        labelText: 'Contact',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Contact';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<String>(
                      value: gender,
                      onChanged: (String? value) {
                        setState(
                          () {
                            gender = value ?? '';
                          },
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                      items: <String>['Male', 'Female', 'Other']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select Gender';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: dob != null
                                  ? '${dob.day}/${dob.month}/${dob.year}'
                                  : '',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                              labelStyle: TextStyle(fontSize: 20),
                              border: OutlineInputBorder(),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 15),
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: dob ?? DateTime.now(),
                                firstDate: DateTime(1000),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  dob = pickedDate;
                                });
                              }
                            },
                            validator: (value) {
                              if (dob == null) {
                                return 'Please select Date of Birth';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dob ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                dob = pickedDate;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        updateUser(
                          widget.id,
                          name,
                          email,
                          password,
                          contact,
                          gender,
                          dob,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blueGrey),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
