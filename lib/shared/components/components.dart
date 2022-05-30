import 'package:bode_flutter/shared/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit ,
  onChanged: onChange,
  onTap: onTap,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? Icon(
      suffix,
    ) : null,
    border: const OutlineInputBorder(),
  ),
);
//---------------------------------------------------------------------------
Widget mySeparator() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20,
    end: 20,
  ),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  ),
);
//---------------------------------------------------------------------------
Widget buildTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Container(
  
    margin: const EdgeInsets.all(13),
  
    padding: const EdgeInsets.all(8),
  
    decoration: BoxDecoration(
  
      color: Colors.grey[200],
  
      borderRadius: BorderRadius.circular(30),
  
    ),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40,
  
          backgroundColor: Colors.white,
  
          child: Text(
  
            '${model['time']}',
  
            style: const TextStyle(
  
              color: Colors.black,
  
              fontWeight: FontWeight.bold,
  
            ),
  
          ),
  
        ),
  
        const SizedBox(width: 20,),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: const TextStyle(
  
                  fontSize: 18,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              const SizedBox(height: 10,),
  
              Text(
  
                '${model['data']}',
  
                style: const TextStyle(
  
                  fontSize: 14,
  
                  color: Colors.black26,
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        const SizedBox(width: 20,),
  
        CircleAvatar(
  
          radius: 20,
  
          backgroundColor: Colors.white,
  
          child: IconButton(
  
              onPressed: ()
  
              {
  
                AppCubit.get(context).UpdateDataBase(status: 'Done', id: model['id']);
  
              },
  
              icon: const FaIcon(FontAwesomeIcons.checkCircle,
  
              color: Colors.black,
  
              ),
  
          ),
  
        ),
  
        const SizedBox(width: 15,),
  
        CircleAvatar(
  
          radius: 20,
  
          backgroundColor: Colors.white,
  
          child: IconButton(
  
              onPressed: (){
  
                AppCubit.get(context).UpdateDataBase(status: 'Archived', id: model['id']);
  
              },
  
              icon: const Icon(
  
                  Icons.archive_outlined,
  
              color: Colors.black,
  
              ),
  
          ),
  
        ),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
//---------------------------------------------------------------------------
Widget toDoBuilder({required List<Map> tasks}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => const SizedBox(height: 0,),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);