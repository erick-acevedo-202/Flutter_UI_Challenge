import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:clase_01/models/category_model.dart';
import 'package:clase_01/models/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProductDatabase {
  static final nameDB = "ProductsDB";
  static final versionDB = 2;

  static Database? _database;

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB); //"$folder/$nameDB";
    //await deleteDatabase(pathDB);
    return openDatabase(pathDB, version: versionDB, onCreate: createTables);
  }

  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  FutureOr<void> createTables(Database db, int version) {
    String queryCategories = '''
    CREATE TABLE tblCategories(
      category_id INTEGER PRIMARY KEY,
      category_name VARCHAR(50) NOT NULL
    )
  ''';
    db.execute(queryCategories);

    String queryProducts = '''
    CREATE TABLE tblProducts(
      product_id INTEGER PRIMARY KEY,
      product_name VARCHAR(80),
      image_path VARCHAR(100),
      price REAL,
      is_favorite INTEGER,
      stars REAL,
      category_id INTEGER,
      description TEXT
    )
  ''';
    db.execute(queryProducts);

    String queryOrder = '''
    CREATE TABLE tblOrder(
      order_id INTEGER PRIMARY KEY,
      date DATE,
      status VARCHAR(15),
      total REAL,
      itemCount INTEGER
    )
  ''';
    db.execute(queryOrder);

    String queryItems = '''
    CREATE TABLE tblItems(
      item_id INTEGER PRIMARY KEY,
      product_id INTEGER,
      order_id INTEGER,
      size VARCHAR(10),
      quantity INTEGER,
      subtotal REAL
    )
  ''';
    db.execute(queryItems);
  }

  Future<bool> categoryExists(String categoryName) async {
    var con = await database;
    final result = await con!.query(
      'tblCategories',
      where: 'category_name = ? COLLATE NOCASE',
      whereArgs: [categoryName],
    );
    return result.isNotEmpty;
  }

  Future<bool> categoryHasProducts(int categoryId) async {
    var con = await database;
    final result = await con!.query(
      'tblProducts',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return result.isNotEmpty;
  }

  Future<int?> getCategoryIdByName(String categoryName) async {
    var con = await database;
    final result = await con!.query(
      'tblCategories',
      where: 'category_name = ?',
      whereArgs: [categoryName],
    );
    if (result.isNotEmpty) {
      return result.first['category_id'] as int;
    }
    return null;
  }

  Future<String?> getCategoryNameById(int id) async {
    var con = await database;
    final result = await con!.query(
      'tblCategories',
      where: 'category_id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['category_name'] as String;
    }
    return null;
  }

  Future<int> INSERT(String table, Map<String, dynamic> data) async {
    var con = await database;
    return con!.insert(table, data);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> data) async {
    var con = await database;

    if (table == 'tblProducts') {
      return con!.update(table, data,
          where: 'product_id = ?', whereArgs: [data['product_id']]);
    } else {
      if (table == 'tblCategories') {
        return con!.update(table, data,
            where: 'category_id = ?', whereArgs: [data['category_id']]);
      } else {
        throw Exception("La tabla ${table} No Existe");
      }
    }
  }
/*
  Future<int> UPDATE_Product_Like(int product_id, int like) async {
    var con = await database;

    final Map<String, dynamic> updatedValues = {
      'is_favorite': like,
    };

    return con!.update('tblProducts', updatedValues,
        where: 'product_id = ?', whereArgs: [product_id]);
  }*/

  Future<int> DELETE(String table, int id) async {
    var con = await database;
    return con!.delete(table,
        where: table == 'tblProducts'
            ? 'product_id = ?'
            : table == 'tblCategories'
                ? 'category_id = ?'
                : throw Exception("La tabla ${table} No Existe"),
        whereArgs: [id]);
  }

  Future<List<ProductModel>> SELECT_Products() async {
    var con = await database;
    final res = await con!.query('tblProducts');
    return res
        .map(
          (product) => ProductModel.fromMap(product),
        )
        .toList();
  }

  Future<List<ProductModel>> SELECTProductsByCategory(int category_id) async {
    var con = await database;
    final res = await con!.query('tblProducts',
        where: 'category_id = ?', whereArgs: [category_id]);
    return res
        .map(
          (product) => ProductModel.fromMap(product),
        )
        .toList();
  }

  Future<List<CategoryModel>> SELECT_Categories() async {
    var con = await database;
    final res = await con!.query('tblCategories');
    return res
        .map(
          (cat) => CategoryModel.fromMap(cat),
        )
        .toList();
  }

  Future<CategoryModel> SELECT_Category_by_id(int category_id) async {
    var con = await database;
    final res = await con!.query('tblCategories',
        where: 'category_id = ?', whereArgs: [category_id]);
    return res as CategoryModel;
  }
}

/*
void main() async {
  ProductDatabase productsDB = ProductDatabase();

  final chocolateFrap = ProductModel(
    product_id: 1,
    product_name: "Chocolate Frappuccino",
    image_path: "assets/sbux_assets/chocolate_frap.png",
    price: 20.0,
    is_favorite: true,
    stars: 4.5,
    //category: "Coffee",
    description:
        "Bebida Fría a hecha con helado de Cacao importado de Oaxxaca por WillyWonka, incluye crema batida y chocolate Hershy's",
  );

  productsDB.INSERT("ProductsDB", {
    "product_id": chocolateFrap.product_id,
    "product_name": chocolateFrap.product_name,
    "image_path": chocolateFrap.image_path,
    "price": chocolateFrap.price,
    "is_favorite": chocolateFrap.is_favorite == true ? 1 : 0,
    "stars": chocolateFrap.stars,
    "description": chocolateFrap.description,
  }).then(
    (value) {
      print("Producto Insertado");
      productsDB.SELECT("ProductsDB");
    },
  );
}*/
