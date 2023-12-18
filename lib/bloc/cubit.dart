import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:simple_todo_list_app/sqlite_files/sql_helper.dart';

import '../model_layer/Task.dart';


part 'states.dart';

class TaskCubit extends Cubit<InitialState>{

  // static List<Task> list_of_tasks = SQLHelper.getAllItems() as List<Task>;

  // static Future<List<Task>> _refreshList()  async{
  //   return list_of_tasks = await SQLHelper.getAllItems();
  // }


  TaskCubit() : super(InitialState(listOfTasks: []));

  void getAllItems() async {
    List<Task> list_of_tasks = await SQLHelper.getAllItems();
    emit(InitialState(listOfTasks: list_of_tasks));
  }


  void addTask(Task newTask, List<Task> list_of_tasks) async {
    // list_of_tasks = await SQLHelper.getAllItems();
    await SQLHelper.createItem(newTask);
    list_of_tasks.add(newTask);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  void deleteTask(int index, List<Task> list_of_tasks) async {
    // list_of_tasks = await SQLHelper.getAllItems();
    await SQLHelper.deleteItem(list_of_tasks[index].id);
    list_of_tasks.removeAt(index);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  void editTask(int id, int index, String title, String dueDate, String finishedTime, List<Task> list_of_tasks) async {
    // list_of_tasks = await SQLHelper.getAllItems();
    list_of_tasks[index].id=id;
    list_of_tasks[index].title=title;
    list_of_tasks[index].dueDate=dueDate;
    list_of_tasks[index].finishedTime=finishedTime;
    // final db = Provider.of<SQLHelper>(context, listen: false);
    await SQLHelper.updateItem(list_of_tasks[index]);
    emit(InitialState(listOfTasks: list_of_tasks));
  }

  // void statesCheck(int index, List<Task> tasks){
  //   _refreshList();
  //   if(tasks[index].isDone=='true'){
  //     emit(InitialState(state: "Completed", listOfTasks: tasks));
  //   }
  //   else if((tasks[index].isDone=='false')&&
  //       (DateFormat('dd-MM-yyyy').parse(_changedlist[index]['dueDate']).isBefore(DateTime.now()))
  //       && (DateFormat('hh:mm').parse(_changedlist[index]['finishedTime']).hour<=DateTime.now().hour
  //           && DateFormat('hh:mm').parse(_changedlist[index]['finishedTime']).minute<=DateTime.now().minute)
  //   ){
  //     emit(InitialState(state: "Not Completed"));
  //   }
  //   else{
  //     emit(InitialState(state: "Active"));
  //   }
  // }
}