import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Liste des articles
  List<Map<String, dynamic>> articles = [];

  // Contrôleurs pour TextFields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Ajouter un nouvel article
  void addArticle() {
    String name = nameController.text;
    String category = categoryController.text;
    double? price = double.tryParse(priceController.text);

    if (name.isEmpty || category.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs 🌸')),
      );
      return;
    }

    setState(() {
      articles.add({
        'name': name,
        'category': category,
        'price': price,
        'bought': false,
      });
      nameController.clear();
      categoryController.clear();
      priceController.clear();
    });
  }

  // Calculer le total du panier
  double getTotal() {
    double total = 0;
    for (var article in articles) {
      if (!article['bought']) {
        total += article['price'];
      }
    }
    return total;
  }

  // Palette de couleurs pastel pour catégories
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cadeau':
        return Colors.pink[200]!;
      case 'vêtements':
        return Colors.purple[200]!;
      case 'déco':
        return Colors.orange[200]!;
      default:
        return Colors.blue[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Wishlist 🌸'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulaire d'ajout
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l’article',
                prefixIcon: Icon(Icons.shopping_bag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Catégorie (Cadeau, Vêtements, Déco...)',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prix',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addArticle,
              child: const Text('Ajouter 🌸'),
            ),
            const SizedBox(height: 20),

            // Liste des articles
            Expanded(
              child: articles.isEmpty
                  ? const Center(child: Text('Aucun article ajouté 💖'))
                  : ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        var article = articles[index];
                        return Card(
                          color: getCategoryColor(article['category']),
                          child: ListTile(
                            leading: Icon(
                              article['bought']
                                  ? Icons.check_circle
                                  : Icons.shopping_cart,
                              color: article['bought'] ? Colors.green : null,
                            ),
                            title: Text(article['name']),
                            subtitle: Text(
                                '${article['category']} - ${article['price'].toStringAsFixed(2)} €'),
                            trailing: Checkbox(
                              value: article['bought'],
                              onChanged: (val) {
                                setState(() {
                                  article['bought'] = val;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Total du panier
            Text(
              'Total du panier : ${getTotal().toStringAsFixed(2)} €',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}
