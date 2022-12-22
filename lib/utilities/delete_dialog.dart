import 'package:flutter/cupertino.dart';
import 'package:mynote_app/utilities/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showGenericDialog
    (context: context,
      title: 'Delete',
      content: 'Are u sure you want to delete',
      optionBuilder: ()=>{
        'Cancel':false,
        'Yes': true,
      }).then((value) => value ?? false);
}