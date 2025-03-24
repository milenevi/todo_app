
import 'dart:async' as _i3;
import 'dart:convert' as _i4;
import 'dart:typed_data' as _i6;

import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;


class _FakeResponse_0 extends _i1.SmartFake implements _i2.Response {
  _FakeResponse_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeStreamedResponse_1 extends _i1.SmartFake
    implements _i2.StreamedResponse {
  _FakeStreamedResponse_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i2.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.Response> head(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(#head, [url], {#headers: headers}),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(#head, [url], {#headers: headers}),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<_i2.Response> get(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(#get, [url], {#headers: headers}),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(#get, [url], {#headers: headers}),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<_i2.Response> post(
      Uri? url, {
        Map<String, String>? headers,
        Object? body,
        _i4.Encoding? encoding,
      }) =>
      (super.noSuchMethod(
        Invocation.method(
          #post,
          [url],
          {#headers: headers, #body: body, #encoding: encoding},
        ),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #post,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<_i2.Response> put(
      Uri? url, {
        Map<String, String>? headers,
        Object? body,
        _i4.Encoding? encoding,
      }) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [url],
          {#headers: headers, #body: body, #encoding: encoding},
        ),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #put,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<_i2.Response> patch(
      Uri? url, {
        Map<String, String>? headers,
        Object? body,
        _i4.Encoding? encoding,
      }) =>
      (super.noSuchMethod(
        Invocation.method(
          #patch,
          [url],
          {#headers: headers, #body: body, #encoding: encoding},
        ),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #patch,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<_i2.Response> delete(
      Uri? url, {
        Map<String, String>? headers,
        Object? body,
        _i4.Encoding? encoding,
      }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [url],
          {#headers: headers, #body: body, #encoding: encoding},
        ),
        returnValue: _i3.Future<_i2.Response>.value(
          _FakeResponse_0(
            this,
            Invocation.method(
              #delete,
              [url],
              {#headers: headers, #body: body, #encoding: encoding},
            ),
          ),
        ),
      )
      as _i3.Future<_i2.Response>);

  @override
  _i3.Future<String> read(Uri? url, {Map<String, String>? headers}) =>
      (super.noSuchMethod(
        Invocation.method(#read, [url], {#headers: headers}),
        returnValue: _i3.Future<String>.value(
          _i5.dummyValue<String>(
            this,
            Invocation.method(#read, [url], {#headers: headers}),
          ),
        ),
      )
      as _i3.Future<String>);

  @override
  _i3.Future<_i6.Uint8List> readBytes(
      Uri? url, {
        Map<String, String>? headers,
      }) =>
      (super.noSuchMethod(
        Invocation.method(#readBytes, [url], {#headers: headers}),
        returnValue: _i3.Future<_i6.Uint8List>.value(_i6.Uint8List(0)),
      )
      as _i3.Future<_i6.Uint8List>);

  @override
  _i3.Future<_i2.StreamedResponse> send(_i2.BaseRequest? request) =>
      (super.noSuchMethod(
        Invocation.method(#send, [request]),
        returnValue: _i3.Future<_i2.StreamedResponse>.value(
          _FakeStreamedResponse_1(
            this,
            Invocation.method(#send, [request]),
          ),
        ),
      )
      as _i3.Future<_i2.StreamedResponse>);

  @override
  void close() => super.noSuchMethod(
    Invocation.method(#close, []),
    returnValueForMissingStub: null,
  );
}
