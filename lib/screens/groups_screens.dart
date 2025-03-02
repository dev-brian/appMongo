//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mongo/models/group_model.dart';
import 'package:mongo/screens/insert_group_screen.dart';
import 'package:mongo/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<GroupModel> groups = [];
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _albumsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _albumsController = TextEditingController();
    _fetchGroups();
  }

  void _fetchGroups() async {
    groups = await MongoService().getGroups();
    print('En fetch: $groups');
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regional Mexicano'),
        backgroundColor: Color.fromARGB(255, 30, 213, 95),
        actions: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InsertGroupScreen(),
                    ),
                  );
                  _fetchGroups();
                },
                child: const Icon(
                  Icons.add,
                  size: 24.0,
                ),
              )),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 18, 18, 18),
        child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            var group = groups[index];
            return oneTile(group);
          },
        ),
      ),
    );
  }

  void _deleteGroup(mongo.ObjectId id) async {
    await MongoService().deleteGroup(id);
    _fetchGroups();
  }

  void _updateGroup(GroupModel group) async {
    await MongoService().updateGroup(group);
    _fetchGroups();
  }

  void _showEditDialog(GroupModel group) {
    //recuperar la informacion del objeto groupmondel
    _nameController.text = group.name;
    _typeController.text = group.type;
    _albumsController.text = group.albums.toString();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar grupo'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                ),
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo',
                ),
              ),
              TextField(
                controller: _albumsController,
                decoration: const InputDecoration(
                  labelText: 'Álbumes',
                ),
              ),
            ]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  group.name = _nameController.text;
                  group.type = _typeController.text;
                  group.albums = int.parse(_albumsController.text);
                  _updateGroup(group);
                  Navigator.pop(context);
                },
                child: const Text('Actualizar'),
              ),
            ],
          );
        });
  }

  ListTile oneTile(GroupModel group) {
    return ListTile(
      tileColor: Colors.white,
      //title: Text(group.name, style: const TextStyle(color: Colors.white)),
      title: Text(group.name, style: Theme.of(context).textTheme.headlineMedium),
      subtitle: Text(group.type, style: const TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => _showEditDialog(group),
              icon: const Icon(Icons.edit),
              color: Colors.white),
          IconButton(
              onPressed: () => _deleteGroup(group.id),
              icon: const Icon(Icons.delete),
              color: Colors.white),
        ],
      ),
    );
  }
}
