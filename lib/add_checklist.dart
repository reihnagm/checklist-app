import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddChecklistPage extends StatefulWidget {
  const AddChecklistPage({super.key});

  @override
  State<AddChecklistPage> createState() => AddChecklistPageState();
}

class AddChecklistPageState extends State<AddChecklistPage> {

  bool isLoading = false;

  late TextEditingController nameC;

  Future<void> createChecklist() async {
    setState(() => isLoading = true);

    try {
      Dio dio = Dio();
      await dio.post("http://94.74.86.174:8080/api/checklist",
        data: {
          "name": nameC.text
        },
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W119.i2OVQdxr08dmIqwP7cWOJk5Ye4fySFUqofl-w6FKbm4EwXTStfm0u-sGhDvDVUqNG8Cc7STtUJlawVAP057Jlg"
          }
        )
      );

      setState(() => isLoading = false);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, 'back');
      });

    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController();
  }

  @override 
  void dispose() {
    nameC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Checklist",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: CupertinoNavigationBarBackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, 'back');
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
          
                TextField(
                  controller: nameC,
                ),

                const SizedBox(height: 20.0),

                ElevatedButton(
                  onPressed: () async {
                    await createChecklist();
                  },
                  child: isLoading 
                  ? const SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ) 
                  : const Text("Create")
                )
          
              ],
            )
          ),
        ),
      )
    );
  }
}