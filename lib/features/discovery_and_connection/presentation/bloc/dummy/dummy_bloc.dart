import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class DummyEvent extends Equatable {
  const DummyEvent();
  @override
  List<Object> get props => [];
}

class DoSomethingDummy extends DummyEvent {}

// States
abstract class DummyState extends Equatable {
  const DummyState();
  @override
  List<Object> get props => [];
}

class DummyInitial extends DummyState {}
class DummyLoading extends DummyState {}
class DummySuccess extends DummyState {}
class DummyError extends DummyState {
  final String message;
  const DummyError(this.message);
  @override
  List<Object> get props => [message];
}

class DummyBloc extends Bloc<DummyEvent, DummyState> {
  DummyBloc() : super(DummyInitial()) {
    on<DoSomethingDummy>((event, emit) async {
      emit(DummyLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(DummySuccess());
    });
  }
}