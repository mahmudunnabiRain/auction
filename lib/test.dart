import 'package:flutter/material.dart';
import 'package:alpha/components/app_bar.dart';
import 'package:alpha/providers/counter_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.pageAppBar(context, 'Test'),
      body: Consumer<CounterModel>(
        builder: (context, counter, child) {
          return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2)
                    ),
                    child: Column(
                      children: [
                      const Text('Mahmudunnabi Rain', style: TextStyle(fontSize: 30),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          onPressed: () {
                            counter.increase();
                          },
                          child: const Text('Increase').tr(),
                        ),
                        Text("${counter.count}", style: const TextStyle(fontSize: 30),),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            counter.decrease();
                          },
                          child: const Text('Decrease').tr(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(40),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 2)
                    ),
                    child: Column(
                      children: [
                        const Text('Test Page', style: TextStyle(fontSize: 30),),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          child: const Text('Pop'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/test');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          child: const Text('push'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/test');
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          child: const Text('push & pop'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushNamed('/test');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          child: const Text('pop & push'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          );
        },
      ),
    );
  }
}

