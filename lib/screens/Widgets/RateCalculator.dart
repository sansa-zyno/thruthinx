import 'package:flutter/material.dart';

class RateCalculation extends StatefulWidget {
  final Function changeRate;
  RateCalculation({required this.changeRate});
  @override
  _RateCalculationState createState() => _RateCalculationState();
}

class _RateCalculationState extends State<RateCalculation> {
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "\$" + _value.toString(),
                    textScaleFactor: 1.4,
                  ),
                  Text(
                    "HOURLY RATE",
                    textScaleFactor: 1.3,
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "\$" + (_value * 6).toString(),
                    textScaleFactor: 1.4,
                  ),
                  Text(
                    "DAY RATE",
                    textScaleFactor: 1.3,
                  )
                ],
              )
            ],
          ),
          Slider(
            value: _value.toDouble(),
            min: 1.0,
            max: 750.0,
            divisions: 10,
            activeColor: Colors.orange,
            inactiveColor: Colors.grey,
            onChanged: (double newValue) {
              setState(() {
                _value = newValue.round();
                widget.changeRate(_value);
              });
            },
          ),
        ],
      ),
    );
  }
}
