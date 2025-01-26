import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:battlegrands_admin/admin_tournament.dart'; // Import your Tournament model
import 'package:intl/intl.dart';

class TournamentDetailsPage extends StatefulWidget {
  final Tournament tournament;

  const TournamentDetailsPage({super.key, required this.tournament});

  @override
  State<TournamentDetailsPage> createState() => _TournamentDetailsPageState();
}

class _TournamentDetailsPageState extends State<TournamentDetailsPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('tournament');
  Map<String, dynamic>? tournamentDetails; // Store details from Firebase

  @override
  void initState() {
    super.initState();
    _loadTournamentDetails();
  }

  Future<void> _loadTournamentDetails() async {
    try {
      final snapshot = await _dbRef.child(widget.tournament.id).get();
      setState(() {
        final data = snapshot.value;

        if (data != null) {
          if (data is Map<String, dynamic>) {
            tournamentDetails = data;
          } else if (data is Map) {
            // Check for the more general Map type
            tournamentDetails =
                data.cast<String, dynamic>(); // Cast if it's a Map
          } else {
            print('Unexpected data type from Firebase: ${data.runtimeType}');
            tournamentDetails = null; // Handle unexpected data
          }
        } else {
          tournamentDetails = null;
        }
      });
    } catch (e) {
      print('Error loading tournament details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(children: [
        Stack(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: ClipRect(
                child: widget.tournament.image != null &&
                        widget.tournament.image!.isNotEmpty
                    ? Image.network(
                        widget.tournament.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print(
                              'Error loading image: $error'); // Print the error object
                          if (error is NetworkImageLoadException) {
                            print(
                                'Specific Network Image Error: ${error.statusCode} ${error.uri}');
                          } else if (error is FlutterError) {
                            print('Flutter Error: ${error.message}');
                          }
                          return Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                          ); // Fallback image
                        },
                      )
                    : Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                      ), // Fallback if URL is null or empty
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
              child: Container(
                height: 290,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      widget.tournament.name ?? 'Tournament Name',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      widget.tournament.leagueType ?? 'One-on-One',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    const SizedBox(height: 20),

                    // const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text('Platform:'),
                        const SizedBox(width: 10),
                        Text(
                          widget.tournament.platform ?? 'platform',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text('Entry Fee: '),
                        Text(
                          widget.tournament.entryFee ?? 'Entry fee',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text('Cashout Prize: '),
                        Text(
                          widget.tournament.cashoutPrize ?? 'prize',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Text('Date: '),
                        Text(
                          widget.tournament.date != null
                              ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                  widget.tournament.date as String))
                              : 'No Date available',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage('assets/logo.png'),
                          ),
                          const SizedBox(width: 5),
                          const Text('Organizer: '),
                          Text(
                            widget.tournament.Organizer ?? 'Admin',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 16),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: SizedBox(
                              child: ElevatedButton(
                                  onPressed: () {}, child: const Text('Enter')),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade300),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 700,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Description"),
                        Tab(text: "Rules"),
                        Tab(text: "Result"),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          // About Tab Content
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              widget.tournament.description ??
                                  "Tournament details.",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              widget.tournament.rules ?? "Rules",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ),

                          // Result Tab Content (Placeholder for now)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                  'Please Indicate whether you Won or Lost'),
                              const SizedBox(height: 20),
                              Container(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {},
                                    child: const Text('Won')),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                height: 50,
                                width: 150,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {},
                                    child: const Text('Lost')),
                              )
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
        )
      ]),
    );
  }
}
