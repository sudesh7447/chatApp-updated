import 'package:flutter/material.dart';




class Suggestions extends StatefulWidget {
  const Suggestions({Key? key}) : super(key: key);

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  final Suggests = [
    SuggestionCard(
      title: 'Suggestion Title',
      date: 'Posted on January 1, 2023',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur ligula non lacus porttitor, in aliquam nulla sollicitudin. Suspendisse tristique, nisi in viverra sagittis, nunc ante accumsan mauris, eu tincidunt neque libero vel quam.',
    ),
    SuggestionCard(
      title: 'Suggestion Title',
      date: 'Posted on January 1, 2023',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed efficitur ligula non lacus porttitor, in aliquam nulla sollicitudin. Suspendisse tristique, nisi in viverra sagittis, nunc ante accumsan mauris, eu tincidunt neque libero vel quam.',
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body : ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return SuggestionCard(
            title: 'title',
            date: 'date',
            description: 'description',
          );
        }
    )
    );
}}
class SuggestionCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;

  const SuggestionCard({Key? key, required this.title, required this.date, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
