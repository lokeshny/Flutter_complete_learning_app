

import 'package:flutter/cupertino.dart';
import 'package:mynote_app/utilities/generic_dialog.dart';

Future<void> showCannotShareEmptyNotDialog(BuildContext context){
  return showGenericDialog<void>(
      context: context,
      title: 'Sharing',
      content: 'You cannot share an empty note',
      optionBuilder: ()=>{
        'OK': null,
      });
}