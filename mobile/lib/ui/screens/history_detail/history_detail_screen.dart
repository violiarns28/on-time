import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          "History Detail",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
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
    );
  }
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
