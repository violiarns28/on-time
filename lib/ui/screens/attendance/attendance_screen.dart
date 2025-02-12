import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 161;
    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Stack(children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                    width: double.infinity,
                    height: formHeight,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: 130,
                              height: 96,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F2F4),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6.0,
                                    spreadRadius: 1.0,
                                    offset: const Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clock In",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Text(
                                    "08:00",
                                    style: TextStyle(
                                        color: Color(0xFF2DBF4D),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              width: 130,
                              height: 96,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F2F4),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6.0,
                                    spreadRadius: 1.0,
                                    offset: const Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clock Out",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.65),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Text(
                                    "18:00",
                                    style: TextStyle(
                                        color: Color(0xFFFF0000),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: 240,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF4098AA)),
                            ),
                            child: const Text(
                              "Clock In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "History",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "All",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                      iconSize: 16,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2F4),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        const Text(
                                          "Name : Genesis Block",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                          "Previous Hash : 0",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                          "Blockchain Hash : f493431dc19e2b21a774165387b579ff43a4e27560d5898e4704aef2ada7335e",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F2F4),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Name : Violia Ruana",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                          "Previous Hash : Previous Hash : f493431dc19e2b21a774165387b579ff43a4e27560d5898e4704aef2ada7335e",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                          "Blockchain Hash : Blockchain Hash : 0000077ce29e9d9e946726497599436614bc53a446cde5b2f9e5ba8aeda46cbd",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Center(
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(8, 4, 8, 4),
                                            height: 130,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFB9E5CA),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Text(
                                              "CLOCK IN : 07-11-2024 at 07:49 WIB",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
