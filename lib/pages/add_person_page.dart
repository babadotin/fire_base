import 'package:fire_base/pages/contact_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key}) : super(key: key);

  @override
  AddPersonPageState createState() => AddPersonPageState();
}

class AddPersonPageState extends State<AddPersonPage> {
  final formKey = GlobalKey<FormState>();
  var name = "";
  var email = "";
  var password = "";
  var contact = "";
  var gender = "";
  DateTime? dob;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final contactController = TextEditingController();
  final dobController = TextEditingController();
  final List<String> genderOptions = ['Male', 'Female', 'Others'];
  String? selectedGender;
  final CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');
  late String selectedEmoji = '𖨆';

  late BuildContext
      modalContext; // Store the context before the async operation

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    contactController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void clearTextFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    contactController.clear();
    dobController.clear();
    setState(
      () {
        selectedGender = null;
        dob = null;
      },
    );
  }

  Future<void> addUser() async {
    try {
      await persons.add(
        {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'contact': contactController.text,
          'gender': gender,
          'dob': dob != null ? Timestamp.fromDate(dob!) : null,
        },
      );
      showSnackBarMessage('Contact saved successfully!');
      clearTextFields();
      Navigator.push(
        // ignore: use_build_context_synchronously
        modalContext,
        MaterialPageRoute(
          builder: (context) =>
              ContactVerifyPage(contact: contactController.text),
        ),
      );
    } catch (error) {
      debugPrint('Failed to add user: $error');
    }
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(
        () {
          dob = pickedDate;
          dobController.text =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        },
      );
    }
  }

  void showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            if (mounted) {
              setState(
                () {
                  selectedEmoji = emoji.emoji;
                },
              );
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void showSnackBarMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Center(
          child: Text(
            "Save to Contact",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: clearTextFields,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: IconButton(
                    onPressed: () => showEmojiPicker(context),
                    icon: Text(
                      selectedEmoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(
                    () {
                      name = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(
                    () {
                      email = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(
                    () {
                      password = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                controller: contactController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(
                    () {
                      contact = value;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: selectedGender,
                items: genderOptions.map(
                  (gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(
                    () {
                      selectedGender = value;
                      gender = value ?? "";
                    },
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: selectDate,
                  ),
                ),
                validator: (value) {
                  if (dob == null) {
                    return 'Please select a date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addUser();
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
