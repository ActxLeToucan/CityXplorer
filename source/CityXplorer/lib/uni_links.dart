import 'dart:async';

import 'package:cityxplorer/pages/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'conf.dart';
import 'models/user.dart';

class UniLinks {
  static Future<void> initUniLinks(BuildContext context) async {
    // Attach a listener to the stream
    StreamSubscription _sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      _openLink(link, context);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      Fluttertoast.showToast(msg: err.toString());
    });
    // NOTE: Don't forget to call _sub.cancel() in dispose()

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      if (initialLink == null) return;

      _openLink(initialLink, context);
    } on PlatformException catch (e) {
      // Handle exception by warning the user their action did not succeed
      // return?
      Fluttertoast.showToast(msg: "${e.message} (erreur ${e.code})");
    } catch (e) {
      print(e);
    }
  }

  static Future<void> _openLink(String? link, BuildContext context) async {
    if (kDebugMode) {
      print(link);
    }
    try {
      if (link == null) {
        throw PlatformException(
            code: '101',
            message: 'Le lien est invalie.',
            details: 'Le lien utilisé pour ouvrir cette application est null.');
      }
      if (!link.startsWith(Conf.domainServer)) {
        throw PlatformException(
            code: '102',
            message: 'Le lien est invalie.',
            details:
                'Le lien utilisé pour ouvrir cette application ne correspond pas à CityXplorer.');
      }

      String path = link.replaceFirst(Conf.domainServer, "");
      if (path.characters.first == '/') path = path.replaceFirst('/', '');

      List<String> list = path.split('/');
      print(list);
      if (list.isEmpty) return;

      switch (list[0]) {
        case 'user':
          {
            _openUser(list, context);
            break;
          }
        case 'post':
          {
            _openPost(list, context);
            break;
          }
        default:
          throw PlatformException(
              code: '110',
              message: 'Le lien est invalie.',
              details:
                  'Le lien utilisé pour ouvrir cette application ne correspond à aucun schéma connu.');
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Fluttertoast.showToast(msg: "${e.message} (erreur ${e.code})");
    }
  }

  static Future<void> _openUser(List<String> list, BuildContext context) async {
    if (list.length < 2) {
      throw PlatformException(
          code: '111',
          message: 'Le lien est invalie.',
          details: 'Le lien utilisé pour ouvrir cette application est null.');
    }
    User user = await User.fromPseudo(list[1]); // TODO si user existe pas
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => UserProfile(user: user)));
  }

  // TODO
  static Future<void> _openPost(List<String> list, BuildContext context) async {
    throw Exception("TODO");
  }
}
