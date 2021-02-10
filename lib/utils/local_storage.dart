import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class LocalStorage {
  final String _tasky = 'tasky';
  Future saveUserInfo(
      {@required int id,
      @required String name,
      @required String picture,
      @required String userId,
      @required String email,
      @required String signInProvider,
      @required String authToken,
      @required int organizationId,
      @required String department,
      @required String fcmToken,
      @required String phoneNumber}) async {
    final Box box = await Hive.openBox(_tasky);
    await box.put('id', id);
    await box.put('name', name);
    await box.put('picture', picture);
    await box.put('user_id', userId);
    await box.put('email', email);
    await box.put('sign_in_provider', signInProvider);
    await box.put('auth_token', authToken);
    await box.put('organizationId', organizationId);
    await box.put('department', department);
    await box.put('fcm_token', fcmToken);
    await box.put('phone_number', phoneNumber);
    await box.put('isAuth', true);
  }

  Future<int> getId() async {
    final Box box = await Hive.openBox(_tasky);
    return await box.get('id');
  }

  Future<String> getName() async {
    final Box box = await Hive.openBox(_tasky);
    return await box.get('name');
  }

  Future<String> getPicture() async {
    final Box box = await Hive.openBox(_tasky);
    return await box.get('picture');
  }

  Future<String> getFirebaseUserId() async {
    final Box box = await Hive.openBox(_tasky);
    return await box.get('user_id');
  }

    Future<int> getOrganizationId() async {
    final Box box = await Hive.openBox(_tasky);
    return await box.get('organizationId');
  }
}
