import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ContactsHomePage extends StatefulWidget {
  const ContactsHomePage({super.key});

  @override
  State<ContactsHomePage> createState() => _ContactsHomePageState();
}

class _ContactsHomePageState extends State<ContactsHomePage> {
  // Liste des contacts récupérés depuis SQLite
  List<Map<String, dynamic>> contacts = [];

  // Contrôleurs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  // Charger les contacts depuis SQLite
  Future<void> loadContacts() async {
    final data = await DBHelper.getContacts();
    setState(() {
      contacts = data;
    });
  }

  // Ajouter un contact dans SQLite
  Future<void> addContact() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    await DBHelper.insertContact(name, phone, email);

    nameController.clear();
    phoneController.clear();
    emailController.clear();

    // Recharger la liste depuis la base
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Mes Contacts'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du contact',
                prefixIcon: Icon(Icons.person, color: Color.fromARGB(255, 215, 142, 228)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone, color: Color.fromARGB(255, 209, 155, 219)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 203, 140, 214)),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: addContact,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 197, 129, 209),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: contacts.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun contact ajouté 🩷',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return Card(
                          color: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Color.fromARGB(255, 204, 149, 213)),
                            title: Text(contact['name']),
                            subtitle: Text('${contact['phone']} • ${contact['email']}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}



