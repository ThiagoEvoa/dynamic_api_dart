import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
//

dynamic json = <dynamic, dynamic>{};

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => get(context),
    HttpMethod.post => post(context),
    _ => Future.value(
        Response(
          statusCode: HttpStatus.methodNotAllowed,
        ),
      )
  };
}

Future<Response> get(RequestContext context) async {
  return Response.json(body: json);
}

Future<Response> post(RequestContext context) async {
  final request = context.request;
  json = json = await request.json();
  return Response.json(body: json);
}
