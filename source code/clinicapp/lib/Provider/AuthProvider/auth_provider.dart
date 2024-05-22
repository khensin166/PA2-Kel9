import 'dart:convert';
import 'dart:io';
import 'package:clinicapp/Constants/url.dart';
import 'package:clinicapp/Model/user_model.dart';
import 'package:clinicapp/Provider/Database/db_provider.dart';
import 'package:clinicapp/Screens/Authentication/login.dart';
import 'package:clinicapp/Screens/Home/main_wrapper.dart';
import 'package:clinicapp/Utils/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  // Pemanggilan base url
  final requestBaseUrl = AppUrl.baseUrl;

  // Setter
  bool _isLoading = false;
  String _resMessage = "";
  UserModel? _userModel;
  Stream<UserModel?>? _userStream;

  // Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  UserModel? get userModel => _userModel;
  Stream<UserModel?>? get userStream => _userStream;

  // Function to fetch user data
  Future<UserModel?> getUserData() async {
    // Here we simulate fetching user data. In real use case, it might be an API call or database query.
    return _userModel;
  }

  // function method untuk registerasi user
  void registerUser(
      {required String username,
      required String password,
      required String passwordConfirmation,
      required String fullname,
      BuildContext? context,
      required int dorm}) async {
    _isLoading = true;
    notifyListeners();

    // Pengecekan apakah password dan passwordConfirmation sama
    if (password != passwordConfirmation) {
      _resMessage = "Password dan Konfirmasi Password tidak cocok";
      _isLoading = false;
      notifyListeners();
      return; // Hentikan eksekusi registerUser jika password tidak cocok
    }
    // pemanggilan api
    String url = "$requestBaseUrl/user";

    // Data yang dikirim
    final body = {
      'name': fullname,
      'username': username,
      'password': password,
      'role': 1.toString(),
      'dormID': dorm.toString()
    };

    print(body);
    try {
      // buat data with post method untuk mengirim data ke api
      http.Response req = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: body);

      // Cetak respons untuk debugging
      print('Response body: ${req.body}');

      // Pengkondisian jika berhasil atau error
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        // variable untuk menamppung respon message
        final message = res['message'];

        // variable untuk menampung respon data
        final userData = res['data'];

        print(message);

        _isLoading = false;
        _resMessage = "Account Created!";
        notifyListeners();
        PageNavigator(ctx: context).nextPageOnly(page: LoginPage());
      } else {
        final res = json.decode(req.body);

        _resMessage = res['message'];
        print(_resMessage);
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (e) {
      _isLoading = false;
      _resMessage = "Internet connection is not available` and ${e.message}";
      print(_resMessage);
      notifyListeners();
    } on http.ClientException catch (e) {
      _isLoading = false;
      _resMessage = "HTTP error ${e.message}";
      print(_resMessage);
      notifyListeners();
    } on FormatException catch (e) {
      _isLoading = false;
      _resMessage = "Server response format is invalid. Please try again.";
      notifyListeners();
      print("Error: Unexpected response format: $e");
    } catch (e) {
      _isLoading = false;
      _resMessage = "Registrasi gagal. Silahkan coba lagi.";
      notifyListeners();
      print(":::: $e");
    }
  }

//Login
  void loginUser({
    required String username,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/userLogin";

    final body = {'username': username, 'password': password};
    print(body);

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
      );

      // Check if response body is not empty before decoding JSON
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        print(res);
        _isLoading = false;
        _resMessage = res['message'];
        notifyListeners();

        ///Save users data and then navigate to homepage

        final token = res['token'] as String;
        final UserID = res['data']['id'].toString();

        print(token);
        DatabaseProvider().saveToken(token);
        DatabaseProvider().saveUserId(UserID);

        // Create UserModel from response data
        final userDataMap = res['data']; // Extracting user data map
        userDataMap['profilePicture'] =
            "http://192.168.76.133:8080/user/image/${userDataMap['profilePicture']}";
        final userDataJsonString =
            json.encode(userDataMap); // Convert user data map to JSON string
        _userModel = userModelFromJson(userDataJsonString);

        PageNavigator(ctx: context).nextPageOnly(page: const MainWrapper());
      } else {
        final res = json.decode(req.body);
        print(res);
        _resMessage = res["message"];
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again";
      notifyListeners();

      print(":::: $e");
    }
  }

  void clear() {
    _resMessage = "";
    // _isLoading is false
    notifyListeners();
  }
}
