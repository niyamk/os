import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Process {
  String name;
  int arrivalTime;
  int burstTime;

  Process(this.name, this.arrivalTime, this.burstTime);
}

class AlphaProcess {
  String name;
  int arrivalTime;
  int burstTime;
  int completionTime;
  int waitingTime;
  int turnAroundTime;
  int responseTime;

  AlphaProcess(
      {required this.name,
      required this.arrivalTime,
      required this.burstTime,
      required this.completionTime,
      required this.turnAroundTime,
      required this.waitingTime,
      required this.responseTime});
}

class _HomePageState extends State<HomePage> {
  TextEditingController processNameController = TextEditingController();
  TextEditingController arrivalTimeController = TextEditingController();
  TextEditingController burstTimeController = TextEditingController();

  double spacing = 20;

  int atat = 0;
  int awt = 0;
  int art = 0;

  List<Process> processes = [
    Process("p1", 1, 3),
    Process("p2", 2, 4),
    Process("p3", 1, 2),
    Process("p4", 4, 4),
  ];

  List<AlphaProcess> alphaProcesses = [];
  void _addButton() {
    processNameController.text = "p${processes.length + 1}";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Process"),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: processNameController,
                decoration: InputDecoration(labelText: "Process Name"),
              ),
              TextFormField(
                controller: arrivalTimeController,
                decoration: InputDecoration(labelText: "Arrival Time"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: burstTimeController,
                decoration: InputDecoration(labelText: "Burst Time"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  processes.add(Process(
                    processNameController.text,
                    int.parse(arrivalTimeController.text),
                    int.parse(burstTimeController.text),
                  ));
                  processNameController.clear();
                  arrivalTimeController.clear();
                  burstTimeController.clear();
                  Navigator.pop(context);
                });
              },
              child: Text("Add")),
          TextButton(
              onPressed: () {
                processNameController.clear();
                arrivalTimeController.clear();
                burstTimeController.clear();
                Navigator.pop(context);
              },
              child: Text("Cancel")),
        ],
      ),
    );
  }

  void _calculate() {
    alphaProcesses.clear();
    processes.sort((a, b) {
      if (a.arrivalTime == b.arrivalTime) {
        return a.burstTime.compareTo(b.burstTime);
      }
      return a.arrivalTime.compareTo(b.arrivalTime);
    });

    int ct = processes[0].arrivalTime + processes[0].burstTime;
    int tat = ct - processes[0].arrivalTime;
    int wt = tat - processes[0].burstTime;
    int rt = wt + processes[0].arrivalTime - processes[0].arrivalTime;
    alphaProcesses.add(AlphaProcess(
        name: processes[0].name,
        arrivalTime: processes[0].arrivalTime,
        burstTime: processes[0].burstTime,
        completionTime: ct,
        waitingTime: wt,
        turnAroundTime: tat,
        responseTime: rt));
    atat = tat;
    awt = wt;
    art = rt;
    log("atat1 : $atat");
    for (int i = 1; i < processes.length; i++) {
      ct += processes[i].burstTime;
      tat = ct - processes[i].arrivalTime;
      wt = tat - processes[i].burstTime;
      rt = wt + processes[i].arrivalTime - processes[i].arrivalTime;
      log("atat2 : $atat");
      atat = (atat + tat);
      log("atat3 : $atat");
      awt = (awt + wt);
      art = (art + rt);
      alphaProcesses.add(AlphaProcess(
          arrivalTime: processes[i].arrivalTime,
          burstTime: processes[i].burstTime,
          name: processes[i].name,
          completionTime: ct,
          waitingTime: wt,
          turnAroundTime: tat,
          responseTime: rt));
    }
    setState(() {});

    processes.sort((a, b) {
      return a.name.compareTo(b.name);
    });
    alphaProcesses.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SJF Calculator'),
        centerTitle: true,
        actions: [
          ElevatedButton(onPressed: _addButton, child: Text("Add Process")),
        ],
      ),
      body: processes.isEmpty
          ? Center(
              child: Text(
              "please add new processes",
              style: TextStyle(fontSize: 20),
            ))
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Table(
                    children: [
                      TableRow(children: const [
                        Center(child: Text("Process ID")),
                        Center(child: Text("Arrival Time")),
                        Center(child: Text("Burst Time")),
                      ]),
                      ...List.generate(
                        processes.length,
                        (index) => TableRow(
                          children: [
                            Center(child: Text(processes[index].name)),
                            Center(child: Text(processes[index].arrivalTime.toString())),
                            Center(child: Text(processes[index].burstTime.toString())),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),
                ElevatedButton(onPressed: _calculate, child: Text("Calculate")),
               SizedBox(height: spacing), alphaProcesses.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Table(
                          children: [
                            TableRow(
                              children: const [
                                Center(child: Text("PID")),
                                Center(child: Text("AT")),
                                Center(child: Text("BT")),
                                Center(child: Text("CT")),
                                Center(child: Text("TAT")),
                                Center(child: Text("WT")),
                                Center(child: Text("RT")),
                              ],
                            ),
                            ...List.generate(
                              alphaProcesses.length,
                              (index) => TableRow(
                                children: [
                                  Center(child: Text(alphaProcesses[index].name)),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .arrivalTime
                                        .toString()),
                                  ),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .burstTime
                                        .toString()),
                                  ),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .completionTime
                                        .toString()),
                                  ),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .turnAroundTime
                                        .toString()),
                                  ),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .waitingTime
                                        .toString()),
                                  ),
                                  Center(
                                    child: Text(alphaProcesses[index]
                                        .responseTime
                                        .toString()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: spacing),alphaProcesses.isEmpty
                    ? SizedBox()
                    : Text(
                        "Average Turn Around Time: ${atat / processes.length} ms\nmean Average Waiting Time: ${awt / processes.length} ms\nAverage Response Time: ${art / processes.length} ms",
                      ),
              ],
            ),
    );
  }
}
