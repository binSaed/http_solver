import 'package:dartz/dartz.dart';
import 'package:http_solver/src/models/models.dart';


extension ModelToEither<T extends BaseModelForHttpSolver> on Future<T> {
  //extends BaseModelForHttpSolver
  Future<Either<Failure, T>> toEither() async {
    //<T extends BaseModelForHttpSolver>
    return await Task(() => this) //put hare ur future
        .attempt() // run ur future in left put error if has in right ur data and return Either
        .mapLeftToFailure() //left side is object and we need to cast to Failure
//        .mapRightToModel<T>() //.map((either) => either.map((baseModel) => baseModel as T ))
        .run();
  }
}

extension ObjToFailure<T extends Either<Object, B>, B> on Task<T> {
  Task<Either<Failure, B>> mapLeftToFailure() {
    return this.map(
          (either) =>
          either.leftMap((obj) {
            try {
              return obj as Failure;
            } catch (e) {
              throw obj;
            }
          }),
    );
  }
}
//
//extension BaseModelToModel<T extends Either<Failure, B>, B> on Task<T> {
////  B: is BaseModel
////  M: is Model
//  Task<Either<Failure, M>> mapRightToModel<M extends BaseModelForHttpSolver>() {
//    return this.map(
//      (either) => either.map((obj) {
//        try {
//          return obj as M;
//        } catch (e) {
//          throw obj;
//        }
//      }),
//    );
//  }
//}
