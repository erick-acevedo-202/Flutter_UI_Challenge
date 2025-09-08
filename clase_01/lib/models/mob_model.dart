class MobModel {
  final String name;
  final double speed;
  final double health;
  final double damage;
  final String image;

  MobModel({
    required this.name,
    required this.speed,
    required this.health,
    required this.damage,
    required this.image,
  });
}

final enderman = MobModel(
    name: "Enderman",
    speed: 50,
    health: 80,
    damage: 75,
    image: "assets/char_enderman.png");
final spider = MobModel(
    name: "Spider",
    speed: 80,
    health: 50,
    damage: 60,
    image: "assets/char_spider.png");
final skeleton = MobModel(
    name: "Skeleton",
    speed: 30,
    health: 60,
    damage: 40,
    image: "assets/char_skeleton.png");

List<MobModel> mobList = [enderman, spider, skeleton];
