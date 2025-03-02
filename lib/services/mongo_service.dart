import 'dart:io';
import 'package:mongo/models/group_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  //un unico punto de acceso
  static final MongoService _instance = MongoService._internal();

  //La base de datos a conectar
  late mongo.Db _db;

  MongoService._internal();
  factory MongoService() {
    return _instance;
  }

  Future<void> connect() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://brianoctavioromeroarellano:EGApqjNaLzI3VDyd@cluster0.za8lw.mongodb.net/musica?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _db.databaseName = 'musica';
      print('Conexión exitosa a MongoDB');
    } on SocketException catch(e) {
      print('Error de conexión: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!_db.isConnected) {
      throw StateError(
          'Base de datos no inicializada, llama a connect() primero');
    }
    return _db;
  }

  Future<List<GroupModel>> getGroups() async {
    final collection = db.collection('grupos');
    print('En MongoServices: $collection');
    var groups = await collection.find().toList();
    print('En MongoServices: $groups');
    if (groups.isEmpty){
      print('No se encontraron grupos en la colección');
    }
    return groups.map((grupo) => GroupModel.fromJson(grupo)).toList();
  }

  Future<void> deleteGroup(mongo.ObjectId id) async {
    final collection = _db.collection('grupos');
    await collection.remove(mongo.where.eq('_id', id));
  }

  Future<void> updateGroup(GroupModel group) async {
    final collection = _db.collection('grupos');
    await collection.updateOne(
      mongo.where.eq('_id', group.id),
      mongo.modify.set('name', group.name).set('type', group.type).set('albums', group.albums),
    );
  }

  Future<void> insertGroup(GroupModel group) async {
    final collection = _db.collection('grupos');
    await collection.insertOne(group.toJson());
  }

  Future<void> close() async {
    await _db.close();
  }

}
