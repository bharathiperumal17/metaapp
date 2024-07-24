import 'package:flutter/material.dart';

class TextRich extends StatelessWidget {
  const TextRich( {super.key,required this.first,required this.second, });
  final String first;
  final String second;
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(text: TextSpan(
          text: first,style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontStyle: FontStyle.italic
          ),
          children: [
            
            TextSpan(
              text: ' ${second}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.normal
              )
            ),
            
          ]
   ),
   
        ),
      
       const SizedBox(height: 20,),
      ],
    );
  }
}