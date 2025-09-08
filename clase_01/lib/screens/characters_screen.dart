import 'package:clase_01/models/mob_model.dart';
import 'package:clase_01/screens/character_details.dart';
import 'package:clase_01/utils/attribute_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

const double rowHeight = 280.0;

double radians(double degrees) {
  return degrees * math.pi / 180;
}

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //LISTA EN mob_model
          for (var mob in mobList) _buildCharacterCard(mob),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(MobModel mob) {
    return Builder(builder: (context) {
      return Container(
        height: rowHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(-10, 0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateY(radians(1.5)),
                child: Container(
                  height: 216,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-44, 0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateY(radians(8)),
                child: Container(
                  height: 188,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(-30, 0),
                child: Container(
                  child: Image.asset(
                    mob.image,
                    width: rowHeight,
                    height: rowHeight,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 58),
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AttributeWidget(
                      progress: mob.speed,
                      child: Image.asset(
                        "assets/icon_speed.png",
                      ),
                    ),
                    SizedBox(height: 12),
                    AttributeWidget(
                      progress: mob.health,
                      child: Image.asset(
                        "assets/icon_health.png",
                      ),
                    ),
                    SizedBox(height: 12),
                    AttributeWidget(
                      progress: mob.damage,
                      child: Image.asset(
                        "assets/icon_damage.png",
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          child: new Text(
                            'See Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(new MaterialPageRoute(builder: (context) {
                              return CharacterDetails(mob);
                            }));
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side:
                                const BorderSide(color: Colors.white, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
