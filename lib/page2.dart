import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeopleListPage extends StatefulWidget {
  const PeopleListPage({super.key});

  @override
  State<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends State<PeopleListPage> {
  List<dynamic> _peopleData = [];

  Future<void> _fetchPeopleData() async {
    try {
      final response =
          await http.get(Uri.parse('https://retoolapi.dev/UKYH2Q/data'));
      if (response.statusCode == 200) {
        setState(() {
          _peopleData = jsonDecode(response.body);
        });
      } else {
        // Handle API error
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPeopleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People List'),
      ),
      body: ListView.builder(
        itemCount: _peopleData.length,
        itemBuilder: (context, index) {
          final person = _peopleData[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(person['Column 4']), // Use 'logo_link'
            ),
            title: Text(person['Column 1']),
            subtitle: Text(person['Column 2']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonDetailsPage(
                    fullName: person['Column 1'],
                    email: person['Column 2'],
                    loremIpsum: person['Column 3'],
                    logoLink: person['Column 4'], // Use 'logo_link'
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PersonDetailsPage extends StatelessWidget {
  final String fullName;
  final String email;
  final String loremIpsum;
  final String logoLink; // Use 'logo_link'

  const PersonDetailsPage({
    Key? key,
    required this.fullName,
    required this.email,
    required this.loremIpsum,
    required this.logoLink, // Use 'logo_link'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fullName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(logoLink), // Use 'logo_link'
            ),
            const SizedBox(height: 20),
            Text('Full Name: $fullName',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Email: $email'),
            const SizedBox(height: 20),
            Text('Lorem Ipsum:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(loremIpsum),
          ],
        ),
      ),
    );
  }
}
