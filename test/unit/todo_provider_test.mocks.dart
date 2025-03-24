
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:todo_app/domain/models/todo.dart' as _i2;
import 'package:todo_app/domain/usecases/todo_usecases.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTodo_0 extends _i1.SmartFake implements _i2.Todo {
  _FakeTodo_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [TodoUseCases].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoUseCases extends _i1.Mock implements _i3.TodoUseCases {
  MockTodoUseCases() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Todo>> getTodos() =>
      (super.noSuchMethod(
            Invocation.method(#getTodos, []),
            returnValue: _i4.Future<List<_i2.Todo>>.value(<_i2.Todo>[]),
          )
          as _i4.Future<List<_i2.Todo>>);

  @override
  _i4.Future<_i2.Todo> getTodoById(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#getTodoById, [id]),
            returnValue: _i4.Future<_i2.Todo>.value(
              _FakeTodo_0(this, Invocation.method(#getTodoById, [id])),
            ),
          )
          as _i4.Future<_i2.Todo>);

  @override
  _i4.Future<void> toggleTodoCompletion(_i2.Todo? todo) =>
      (super.noSuchMethod(
            Invocation.method(#toggleTodoCompletion, [todo]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> addTodo(String? title) =>
      (super.noSuchMethod(
            Invocation.method(#addTodo, [title]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> deleteTodo(int? id) =>
      (super.noSuchMethod(
            Invocation.method(#deleteTodo, [id]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> updateTodo(_i2.Todo? todo) =>
      (super.noSuchMethod(
            Invocation.method(#updateTodo, [todo]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> dispose() =>
      (super.noSuchMethod(
            Invocation.method(#dispose, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
