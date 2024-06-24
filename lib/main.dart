import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/menu_provider.dart';
import 'models/menu_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuProvider()..loadMenuData(),
      child: MaterialApp(
        title: 'Restaurant Menu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MenuSearchScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MenuSearchScreen extends StatefulWidget {
  @override
  _MenuSearchScreenState createState() => _MenuSearchScreenState();
}

class _MenuSearchScreenState extends State<MenuSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<MenuItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);
      setState(() {
        _searchResults = menuProvider.items; // Show entire menu by default
      });
    });
  }

  void _search(String query) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    setState(() {
      _searchResults = menuProvider.searchMenu(query);
    });
  }

  void _showCategories() {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: SingleChildScrollView(
            child: Column(
              children: menuProvider.categories.map((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    setState(() {
                      _searchResults = menuProvider.filterByCategory(category);
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pho Saigon Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: _showCategories,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search by Number or Name',
                border: OutlineInputBorder(),
              ),
              onChanged: _search,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    Map<String, List<MenuItem>> categorizedResults = {};
    for (var item in _searchResults) {
      if (!categorizedResults.containsKey(item.category)) {
        categorizedResults[item.category] = [];
      }
      categorizedResults[item.category]!.add(item);
    }

    return ListView(
      children: categorizedResults.keys.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...categorizedResults[category]!.map((item) {
              return ListTile(
                title: Text('${item.number} - ${item.englishName}'),
                subtitle: Text(item.vietnameseName),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}
