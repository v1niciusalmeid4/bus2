import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:bus2/core/core.dart';
import 'package:bus2/src/models/models.dart';
import 'package:bus2/src/repositories/repositories.dart';

class UserRemoteRepository {
  final UserLocalRepository local;

  UserRemoteRepository({required this.local});

  final baseUrl = 'https://randomuser.me';
  final _client = http.Client();

  Future<Result> findUsers({required int size, required int page}) async {
    final endpoint = '/api/';

    final uri = Uri.parse(baseUrl)
        .resolve(endpoint)
        .replace(
          queryParameters: {
            'results': size.toString(),
            'page': page.toString(),
          },
        );

    final response = await _client.get(uri);

    if (response.bodyBytes.isEmpty) {
      return Failure('Nenhum usuario encontrado!');
    }

    final responseBody = utf8.decode(response.bodyBytes);

    final list = jsonDecode(responseBody)['results'] as List;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final users = list.map(UserModel.fromMap).toList();

      local.saveUsers(users);

      return Success(users);
    }

    return Failure('Falha na API!');
  }
}
