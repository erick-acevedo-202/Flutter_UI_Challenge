import 'package:clase_01/database/product_database.dart';
import 'package:clase_01/widgets/order_expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryCalendar extends StatefulWidget {
  const HistoryCalendar({super.key});

  @override
  State<HistoryCalendar> createState() => _HistoryCalendarState();
}

class _HistoryCalendarState extends State<HistoryCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  ProductDatabase? productsDB;

  Map<DateTime, int> _starsData = {};

  @override
  void initState() {
    super.initState();
    productsDB = ProductDatabase();
    _loadStarsData();
  }

  void _loadStarsData() async {
    productsDB!.getStarPointsByDate().then(
      (starsMap) {
        setState(() {
          _starsData = starsMap;
          print("STARS MAP: ${starsMap}");
        });
      },
    );
  }

  Widget _buildDayWithStars(DateTime day, int stars) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}'),
          if (stars > 0) Text('⭐$stars', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSelectedDayWithStars(DateTime day, int stars, Color dayColor) {
    return Container(
      margin: EdgeInsets.all(2),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: dayColor,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}', style: TextStyle(color: Colors.white)),
          if (stars > 0)
            Text('⭐$stars',
                style: TextStyle(fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Calendar"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              print('Selected Date: $selectedDay');
              print('Star Points: ${_starsData[selectedDay] ?? 0}');
              print(
                  "SELECTED DAY: ${_selectedDay.toString().substring(0, 10)}");
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final stars = _starsData[day] ?? 0;
                return _buildDayWithStars(day, stars);
              },
              selectedBuilder: (context, day, focusedDay) {
                final stars = _starsData[day] ?? 0;
                return _buildSelectedDayWithStars(
                    day, stars, Color.fromARGB(150, 4, 112, 0));
              },
              todayBuilder: (context, day, focusedDay) {
                final stars = _starsData[day] ?? 0;
                return _buildSelectedDayWithStars(
                    day, stars, Color.fromARGB(255, 0, 98, 59));
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            '⭐ ${_starsData[_selectedDay] ?? 0} stars obtained in ${_selectedDay.day} / ${_selectedDay.month}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
              child: OrderExpansionWidget(
                  date: _selectedDay.toString().substring(0, 10)))
        ],
      ),
    );
  }
}
