import 'package:flutter/cupertino.dart';
import 'package:mynote_app/utilities/generic_dialog.dart';

Future<void> showErrorDialog(
    BuildContext context,
    String text,
    ){
  return showGenericDialog(
      context: context,
      title: 'An Error occured',
      content: text,
      optionBuilder: ()=>{
        'OK':null
      });
}