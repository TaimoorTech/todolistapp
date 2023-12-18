import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_todo_list_app/bloc/cubit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_todo_list_app/screens/bottom_sheet.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';
import '../model_layer/task.dart';
import 'list_view_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _finishedTimeController = TextEditingController();
  final TextEditingController _searchBarController = TextEditingController();

  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void display_message(String message){
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.black,
        fontSize: 15,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }

  void showForm(int? id, int index, List<Task> listOfTask) {

    if(id != null){
      final existingItem = listOfTask.firstWhere((element) => element.id == id);
      _titleController.text = existingItem.title;
      _dueDateController.text = existingItem.dueDate;
      _finishedTimeController.text = existingItem.finishedTime;
    }
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => ModelBottomSheet(
            id: id, contexts: context, index: index, listOfTask: listOfTask,
            titleController: _titleController, dueDateController: _dueDateController,
            finishedTimeController: _finishedTimeController)
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
         backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 5,
            title: Text("ToDo List App"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                List<Task> list = await SQLHelper.getAllItems();
                _titleController.text='';
                _dueDateController.text='';
                _finishedTimeController.text='';
                showForm(null, 0, list);
              },
              child: Icon(
                Icons.add
              ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                searchBar(),
                SizedBox(height: 30),
                Text("All Tasks", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 30),
                showList()

              ],
            ),
          ),
      ),
    );
  }


  Widget showList() {
    return Expanded(
      // height: MediaQuery. of(context). size. height-230,
      child: BlocBuilder<TaskCubit, TaskListing>(
        builder: (BuildContext context, TaskListing state) => ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: state.listOfTasks.length,
              itemBuilder: (context, index) => ListViewCard(function: showForm, id: state.listOfTasks[index].id, contexts: context, index: index, listOfTask: state.listOfTasks,
                  titleController: _titleController, dueDateController: _dueDateController,
                  finishedTimeController: _finishedTimeController)
          ),
      ),
    );
  }

  // void _runFilter(String value) async {
  //   List <Task> result = [];
  //   if(value.isEmpty){
  //     // result = state.listOfTasks;
  //   }
  //   else{
  //     // result = await SQLHelper.searchItem(value);
  //   }
  //   setState(() {
  //     // listOfTasks = result;
  //     // _refresh();
  //   });
  // }

  Widget searchBar() {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16)
      ),
      child:  TextField(//Search Bar
        style: TextStyle(color: Colors.white,
            fontSize: 19),
        controller: _searchBarController,
        onChanged: (value) => {
          // _runFilter(value.trim())
        },
        onTapOutside: (event){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        cursorWidth: 2,
        cursorHeight: 20,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_sharp,
              color: Colors.white,
              size: 19,
            ),
            border: InputBorder.none,
            hintText: "Search Task",
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 19
            )
        ),
      ),
    );
  }

}

