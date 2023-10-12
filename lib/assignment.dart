
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// json model class
class Json_model
{
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const Json_model
  (
      {
      required this.postId,
      required this.id,
      required this.name,
      required this.email,
      required this.body,
    }
  );

  factory Json_model.fromJson(Map<String, dynamic> json) 
  {
    return Json_model
    (
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}
Future<List<Json_model>> fetchUsers() async 
{
  final Api_response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));  //get the http data

  if (Api_response.statusCode == 200) 
  {
    List<dynamic> _parsedListJson = jsonDecode(Api_response.body);  //converting http data into json
    List<Json_model> _itemsList = List<Json_model>.from
    (
      _parsedListJson.map<Json_model>((dynamic index) => Json_model.fromJson(index)),
    );
    return _itemsList;
  } 
  else 
  {
    throw Exception('Failed to load the Users');
  }
}



class assignmnet1 extends StatelessWidget
{
  const assignmnet1({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      
      appBar:  AppBar
      (
        title: const Text('comments', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
        centerTitle:  true,
        leading:  IconButton
        (
          icon: const Icon
          (
            Icons.menu,
          ),
          onPressed: (){},
        ),

        actions: <Widget>
        [
          IconButton(onPressed: (){}, icon: const Icon(Icons.person)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.alarm_on_rounded)),
        ],
      ),

      body: FutureBuilder<List<Json_model>>
      (
        future: fetchUsers(),
        builder: (context, snapshot) 
        {
          if(snapshot.hasData)
          {
            return ListView.builder
            (
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index)
              {
                var item=snapshot.data![index];
                return GestureDetector
                (
                  onTap: ()
                  {
                    showBottomSheet
                    (
                      context: context, 
                       shape: const RoundedRectangleBorder
                      (
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      builder: (context)
                      {
                        return Padding
                        (
                          padding: const EdgeInsets.all(8.0),
                          child: Column
                            (

                              children: 
                              [
                                Text('Name: ${item.name}'),
                                Text('Email: ${item.email}'),
                                Text('Body: ${item.body}'),
                              ],
                        
                            ),
                        );
                      }
                    );
                  },
                  child: ListTile
                  (
                    title: Text('name: ${item.name??''}'),
                    leading: CircleAvatar
                    (
                      backgroundColor: Colors.blue,
                      child: Text((index+1).toString()),
                    ),
                  ),
                );
               
              },
            );
          }
          else if (snapshot.hasError) 
          {
            return Center
            (
              child: Text('Error: ${snapshot.error}'),
            );
          } 
          else 
          {
            return const Center
            (
              child: Text
              (
                'Loading.......',
                style: TextStyle
                (
                  fontSize: 35, 
                ),
              ),
            );
          }
        },
      ),

    );
  }
}