import 'package:flutter/cupertino.dart';
import 'package:mynote_app/utilities/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context){
  return showGenericDialog
    (context: context,
      title: 'Log out',
      content: 'Are u sure you want to logout',
      optionBuilder: ()=>{
      'Cancel':false,
        'Log out': true,
      }).then((value) => value ?? false);
}