import 'models/word.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Proxy {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Proxy();

  Future<dynamic> upsert(dynamic item) async {
    final String collection;
    switch (item.runtimeType) {
      case Word:
        collection = 'word';
        break;
      default:
        throw Exception('Unknown Type');
    }

    final ref = _getRef(collection);

    if (item.id == null) {
      return await ref.add(item);
    } else {
      return await ref.doc(item.id).set(item);
    }
  }

  Future<dynamic> get(String collection, String id) async {
    final ref = _getRef(collection);
    final snapshot = await ref.doc(id).get();
    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  }

  CollectionReference<Object> _getRef(String collection) {
    return firestore.collection(collection).withConverter(
          fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot,
              SnapshotOptions? options) {
            switch (collection) {
              case 'words':
                return Word.fromFirestore(snapshot, options);
              default:
                throw Exception('Unknown type');
            }
          },
          toFirestore: (dynamic item, _) => item.toFirestore(),
        );
  }

  Future<Iterable<dynamic>> list(String collection) async {
    final ref = _getRef(collection);
    final snapshot =
        await ref.get().then((value) => value.docs.map((e) => e.data()));
    return snapshot;
  }

  Future<Iterable<dynamic>> listWhere(String collection, String attribute,
      dynamic value, String operator) async {
    final ref = _getRef(collection);
    var query = ref.where(attribute, isEqualTo: value);

    switch (operator) {
      case "=":
        query = ref.where(attribute, isEqualTo: value);
        break;
      case "!=":
        query = ref.where(attribute, isNotEqualTo: value);
        break;
      case "<":
        query = ref.where(attribute, isLessThan: value);
        break;
      case "<=":
        query = ref.where(attribute, isLessThanOrEqualTo: value);
        break;
      case ">":
        query = ref.where(attribute, isGreaterThan: value);
        break;
      case ">=":
        query = ref.where(attribute, isGreaterThanOrEqualTo: value);
        break;
      default:
    }
    final snapshot =
        await query.get().then((value) => value.docs.map((e) => e.data()));
    return snapshot;
  }
}
