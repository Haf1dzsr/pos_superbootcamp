import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';

part 'product_state.dart';
part 'product_cubit.freezed.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState.initial());

  Future<void> addProduct(String name, String description, int price, int stock,
      File? image) async {
    emit(const ProductState.loading());

    final product = ProductModel(
        name: name, description: description, price: price, stock: stock);
    final result =
        await ProductRemoteDatasource.instance.addProduct(product, image);

    result.fold(
      (failure) => emit(ProductState.error(failure)),
      (_) => emit(const ProductState.success()),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      emit(ProductState.imagePicked(File(pickedFile.path)));
    } else {
      emit(const ProductState.imageNotPicked());
    }
  }
}
