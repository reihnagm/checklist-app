import 'package:checklist_app/add_checklist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => ChecklistPageState();
}

class ChecklistPageState extends State<ChecklistPage> {

  bool isLoading = true;
  
  List<dynamic> checkList = [];

  Future<void> getData() async {
    try {
      Dio dio = Dio();
      Response res = await dio.get("http://94.74.86.174:8080/api/checklist",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W119.i2OVQdxr08dmIqwP7cWOJk5Ye4fySFUqofl-w6FKbm4EwXTStfm0u-sGhDvDVUqNG8Cc7STtUJlawVAP057Jlg"
          }
        )
      );
      Map<String, dynamic> data = res.data;
      List dataList = data['data'];
      
      checkList = [];

      isLoading = false;

      setState(() => checkList.addAll(dataList));

    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> deleteChecklist(int id) async {
    setState(() => isLoading = true);

    try {
      Dio dio = Dio();
      await dio.delete("http://94.74.86.174:8080/api/checklist/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W119.i2OVQdxr08dmIqwP7cWOJk5Ye4fySFUqofl-w6FKbm4EwXTStfm0u-sGhDvDVUqNG8Cc7STtUJlawVAP057Jlg"
          }
        )
      );

      setState(() {
        isLoading = false;
        getData();
      });

    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  @override 
  void initState() {
    super.initState();

    Future.microtask(() => getData());
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              title: const Text("Checklist App",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              centerTitle: true,
              actions: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 18.0,
                    right: 18.0
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        final data = await Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const AddChecklistPage()
                          ),
                        );
                        if(data != null) {
                          getData();
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              ],
            )
          ];
        }, 
        body: RefreshIndicator.adaptive(
          onRefresh: () {
            return Future.sync(() {
              getData();
            });
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
          
              if(isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                ),

              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList.builder(
                  itemCount: checkList.length,
                  itemBuilder: (_, int i) {
                    return ListTile(
                      title: Text(checkList[i]["name"],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            await deleteChecklist(checkList[i]["id"]);
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        ),
                      ),
                    );
                  },
                ),
              )
          
            ],
          ),
        )
      )
    );
  }
}