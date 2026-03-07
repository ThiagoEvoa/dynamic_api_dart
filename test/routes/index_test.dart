import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

void main() {
  late RequestContext context;
  late Request request;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    when(() => context.request).thenReturn(request);
    route.json = <dynamic, dynamic>{};
  });

  group('onRequest', () {
    test('responds with 405 when method is not allowed', () async {
      when(() => request.method).thenReturn(HttpMethod.put);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('GET responds with 200 and empty json', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals({}));
    });

    test('POST updates json and responds with 200', () async {
      final data = {'foo': 'bar'};
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async => data);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(await response.json(), equals(data));
      expect(route.json, equals(data));
    });
  });
}
