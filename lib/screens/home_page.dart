import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart';

class ContactsHomePage extends StatefulWidget {
  const ContactsHomePage({super.key});

  @override
State<ContactsHomePage> createState() => _ContactsHomePageState();
}

class _ContactsHomePageState extends State<ContactsHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final data = await DBHelper.getContacts();
    if (mounted) {
      setState(() {
        contacts = data;
      });
    }
  }

  Future<void> addContact() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await DBHelper.insertContact(name, phone, email);
    nameController.clear();
    phoneController.clear();
    emailController.clear();

    _loadContacts(); // Rafraîchir la liste
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("EasyContact", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // === FORMULAIRE D'AJOUT ===
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Nom",
                          prefixIcon: Icon(Icons.person, color: Color(0xFFD78EE4)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Téléphone",
                          prefixIcon: Icon(Icons.phone, color: Color(0xFFD19BDB)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email, color: Color(0xFFCB8CD6)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: addContact,
                          icon: const Icon(Icons.add),
                          label: const Text("Ajouter le contact", style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC581D1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // === LISTE DES CONTACTS ===
              Expanded(
                child: contacts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.contacts, size: 64, color: Colors.purple[200]),
                            const SizedBox(height: 16),
                            Text(
                              "Aucun contact ajouté",
                              style: TextStyle(fontSize: 18, color: Colors.purple[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final c = contacts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.purple[100],
                                child: Text(
                                  c['name'][0].toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                                ),
                              ),
                              title: Text(c['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text("${c['phone']} • ${c['email']}", style: TextStyle(color: Colors.grey[600])),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Bouton Modifier
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditListPage(),
                                        ),
                                      );
                                      _loadContacts(); // Rafraîchir après modification
                                    },
                                  ),
                                  // Bouton Supprimer
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DeleteListPage(),
                                        ),
                                      );
                                      _loadContacts(); // Rafraîchir après suppression
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






