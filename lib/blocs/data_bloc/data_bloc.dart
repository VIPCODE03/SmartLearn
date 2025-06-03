// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smart_learn/blocs/data_bloc/data_load.dart';
//
// /// --- Định nghĩa các sự kiện ---
// abstract class DataEvent<T> {}
//
// abstract class LoadDataEvent<T> extends DataEvent<T> {}
//
// abstract class UpdateDataEvent<T> extends DataEvent<T> {}
//
// /// --- Định nghĩa các trạng thái ---
// abstract class DataState<T> {}
//
// class LoadingDataState<T> extends DataState<T> {}
//
// class LoadedDataState<T> extends DataState<T> {
//   final T data;
//   LoadedDataState({required this.data});
// }
//
// class UpdatingDataState<T> extends DataState<T> {}
//
// class UpdatedDataState<T> extends DataState<T> {
//   final T data;
//   UpdatedDataState({required this.data});
// }
//
// class ErrorDataState<T> extends DataState<T> {
//   final String error;
//   ErrorDataState({required this.error});
// }
//
// /// --- Bloc chung để quản lý các kiểu dữ liệu ---
// class DataBloc<T> extends Bloc<DataEvent<T>, DataState<T>> with DataLoad {
//
//   DataBloc() : super(LoadingDataState<T>()) {
//     on<LoadDataEvent<T>>((event, emit) async {
//       emit(LoadingDataState());
//       try {
//         final result = await load(event);
//         final T data = result as T;
//         emit(LoadedDataState(data: data));
//       }
//       catch (e) {
//         debugPrint(e.toString());
//         emit(ErrorDataState(error: e.toString()));
//       }
//     });
//
//     on<UpdateDataEvent<T>>((event, emit) async {
//       emit(UpdatingDataState()); // Phát ra trạng thái đang cập nhật (tùy chọn)
//       try {
//         // Gọi service để cập nhật dữ liệu (ví dụ: await yourService.updateData(event.data);)
//         // Giả sử service trả về dữ liệu đã cập nhật
//         // T data updatedData = await yourService.updateData(event.data);
//         // emit(UpdatedDataState(data: event.data));
//         // Phát ra trạng thái đã cập nhật
//       } catch (e) {
//         emit(ErrorDataState(error: e.toString()));
//       }
//     });
//   }
// }