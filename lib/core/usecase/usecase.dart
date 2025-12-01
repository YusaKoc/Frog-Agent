import 'package:dartz/dartz.dart';
import 'package:frog_agent/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

abstract class StreamUseCase<Type, Params> {
  Either<Failure, Stream<Type>> call(Params params);
}
