import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:on_time/ui/screens/history_detail/history_detail_screen.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-7.341591059504343, 112.736106577182336);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final formHeight = height - 339;

    return Scaffold(
      backgroundColor: const Color(0xFF96D4E1),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: {
              const Marker(
                markerId: MarkerId('currentLocation'),
                position: LatLng(-7.341591059504343, 112.73610657718233),
              ),
            },
          ),
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
                      margin: const EdgeInsets.only(top: 189),
                      padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
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
                              _buildClockContainer(
                                  "Clock In", "08:00", const Color(0xFF2DBF4D)),
                              const SizedBox(width: 16.0),
                              _buildClockContainer("Clock Out", "18:00",
                                  const Color(0xFFFF0000)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 240,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    const Color(0xFF4098AA)),
                              ),
                              child: const Text(
                                "Clock In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "History",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HistoryDetailScreen()),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "See all",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildHistoryItem(
                                    "Genesis Block",
                                    "0",
                                    "f493431dc19e2b21a774165387b579ff43a4e27560d5898e4704aef2ada7335e",
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryItem(
                                    "Violia Ruana",
                                    "f493431dc19e2b21a774165387b579ff43a4e27560d5898e4704aef2ada7335e",
                                    "0000077ce29e9d9e946726497599436614bc53a446cde5b2f9e5ba8aeda46cbd",
                                    showClockIn: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryItem(
                                    "Violia Ruana",
                                    "1122399bh04n9j9f99u4u934unf9kmavd83b940bvu0e9b02183vwqvds12j0de7",
                                    "0000077ce29e9d9e946726497599436614bc53a446cde5b2f9e5ba8aeda46cbd",
                                    showClockOut: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildHistoryItem(
                                    "Moana",
                                    "0000077ce29e9d9e946726497599436614bc53a446cde5b2f9e5ba8aeda46cbd",
                                    "1122399bh04n9j9f99u4u934unf9kmavd83b940bvu0e9b02183vwqvds12j0de7",
                                    showClockIn: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 250.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: height / 11.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xFF0E5D6D),
                      Color(0xFF3C94A5),
                    ],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Ketintang, Surabaya",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClockContainer(String title, String time, Color timeColor) {
    return Container(
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
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.65),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: timeColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String name,
    String prevHash,
    String blockchainHash, {
    bool showClockIn = false,
    bool showClockOut = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F2F4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Name : $name",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Previous Hash : $prevHash",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Blockchain Hash : $blockchainHash",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            if (showClockIn) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFB9E5CA),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Center(
                  child: Text(
                    "CLOCK IN : 07-11-2024 at 07:49 WIB",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            if (showClockOut) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEB5B7),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Center(
                  child: Text(
                    "CLOCK OUT : 07-11-2024 at 17:49 WIB",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
