import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

dynamic dynamicJson = <dynamic, dynamic>{};

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
  return Response.json(body: dynamicJson);
}

Future<Response> post(RequestContext context) async {
  final request = context.request;
  dynamicJson = dynamicJson = await request.json();
  return Response.json(body: dynamicJson);
}
