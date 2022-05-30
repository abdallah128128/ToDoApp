import 'package:bode_flutter/shared/components/components.dart';
import 'package:bode_flutter/shared/cubit/cubit.dart';
import 'package:bode_flutter/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchivedTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks=AppCubit.get(context).archivedTasks;
        return toDoBuilder(
          tasks: tasks,
        );
      },
    );
  }
}
