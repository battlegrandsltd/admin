import 'package:battlegrands_admin/admin_tournament_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';

class AdminTournament extends StatefulWidget {
  const AdminTournament({super.key});

  @override
  State<AdminTournament> createState() => _AdminTournamentState();
}

class Tournament {
  final String id;
  final String cashoutPrize;
  final String entryFee;
  final String game;
  final String platform;
  final String? description;
  final String? leagueType;
  final String? Organizer;
  final String? name;
  final String? rules;
  final String? entryType;
  final String? image;
  final dynamic date;

  Tournament(
      {required this.id,
      required this.cashoutPrize,
      required this.entryFee,
      required this.game,
      required this.platform,
      this.description,
      this.leagueType,
      this.Organizer,
      this.entryType,
      this.name,
      required this.date,
      this.image,
      this.rules});
}

class _AdminTournamentState extends State<AdminTournament> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('tournament');
  List<Tournament> _tournaments = [];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  Future<void> _deleteTournament(
      String tournamentId, String? imageUrl, BuildContext context) async {
    try {
      // 1. Delete from Realtime Database
      DatabaseReference database =
          FirebaseDatabase.instance.ref('tournament/$tournamentId');
      await database.remove();
      print(
          'Tournament with ID: $tournamentId successfully deleted from database');

      // 2. Delete the image from Storage (if imageUrl is provided)
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          // *** THE FIX IS HERE ***
          // Get the storage reference from the full URL
          final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

          // Extract the path from the reference
          final path = storageRef.fullPath;

          // Create a new reference using the path
          final correctRef = FirebaseStorage.instance.ref().child(path);

          await correctRef.delete();
          print('Image at $imageUrl successfully deleted from storage');
        } on FirebaseException catch (storageError) {
          // Handle Storage-specific errors
          if (storageError.code == 'object-not-found') {
            print('Image not found in storage. Skipping deletion.');
          } else {
            print('Error deleting image from storage: $storageError');
            ScaffoldMessenger.of(context).showSnackBar(
              // Show error to user
              SnackBar(
                  content:
                      Text('Error deleting image: ${storageError.message}')),
            );
          }
        } catch (e) {
          print('Unexpected error deleting image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            // Show error to user
            SnackBar(content: Text('Unexpected error deleting image: $e')),
          );
        }
      } else {
        print('No image URL provided for deletion.');
      }

      // 3. Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tournament Deleted Successfully')),
      );
    } catch (databaseError) {
      print("Error deleting tournament from database: $databaseError");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Deleting Tournament: $databaseError')),
      );
    }
  }

/*   void _activateListeners() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final tournaments = data.entries.map((entry) {
          final id = entry.key; // Firebase's unique key
          final details = entry.value as Map?;
          return Tournament(
            id: id,
            cashoutPrize: details?['cashoutPrize']?.toString() ?? 'N/A',
            entryFee: details?['entryFee']?.toString() ?? 'N/A',
            game: details?['game']?.toString() ?? 'N/A',
            platform: details?['platform']?.toString() ?? 'N/A',
            description: details?['tournamentDescription']?.toString(),
            leagueType: details?['leagueType']?.toString(),
            Organizer: details?['organizer']?.toString(),
            name: details?['tournamentName']?.toString(),
            rules: details?['tournamentRules']?.toString(),
          );
        }).toList();

        setState(() {
          _tournaments =
              tournaments; // Assuming _tournaments is a List<Tournament>
        });
      }
    });
  } */
  void _activateListeners() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value
          as Map<dynamic, dynamic>?; // Use dynamic for flexibility
      if (data != null) {
        final tournaments = data.entries
            .map((entry) {
              final id = entry.key as String; // Ensure the key is a String
              final details = entry.value
                  as Map<dynamic, dynamic>?; // Cast value dynamically
              if (details == null) return null;

              return Tournament(
                id: id,
                cashoutPrize: details['cashoutPrize']?.toString() ?? 'N/A',
                entryFee: details['entryFee']?.toString() ?? 'N/A',
                game: details['game']?.toString() ?? 'N/A',
                platform: details['platform']?.toString() ?? 'N/A',
                description: details['tournamentDescription']?.toString(),
                leagueType: details['leagueType']?.toString() ?? 'N/A',
                Organizer: details['organizer']?.toString() ?? 'N/A',
                name: details['tournamentName']?.toString() ?? 'N/A',
                rules: details['tournamentRules']?.toString() ?? 'N/A',
                entryType: details['entryType']?.toString() ?? 'N/A',
                image: details['imageUrl']?.toString() ?? 'N/A',
                date: details['created_at']?.toString() ?? 'N/A',
              );
            })
            .whereType<Tournament>()
            .toList(); // Filter out null values safely

        setState(() {
          _tournaments =
              tournaments; // Assuming _tournaments is List<Tournament>
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _errorMessage != null
            ? Center(
                child: Text(
                  'Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : _tournaments.isEmpty
                ? const Center(child: Text('No tournaments available'))
                : ListView.builder(
                    itemCount: _tournaments.length,
                    itemBuilder: (context, index) {
                      final tournament = _tournaments[index];
                      return Card(
                        // Use Card for better visual separation
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: tournament.image != null &&
                                        tournament.image!.isNotEmpty
                                    ? Image.network(
                                        tournament.image!,
                                        fit: BoxFit.cover,
                                        height:
                                            150, // Set a fixed height for the image
                                        width: double.infinity,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print('Error loading image: $error');
                                          return Image.asset(
                                            'assets/logo.png',
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: double.infinity,
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        'assets/logo.png',
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: double.infinity,
                                      ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Name: ${tournament.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text('Game: ${tournament.game}'),
                              Text('Platform: ${tournament.platform}'),
                              // const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Cashout Prize: ${tournament.cashoutPrize}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Entry Fee: ${tournament.entryFee}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TournamentDetailsPage(
                                                tournament: tournament),
                                      ),
                                    ),
                                    icon: const Icon(Icons.info_outline),
                                    label: const Text('Details'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: IconButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Delete Confirmation'),
                                            content: const Text(
                                                'Are you sure you want to delete this tournament?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                  _deleteTournament(
                                                      tournament.id,
                                                      tournament.image,
                                                      context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
