import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/category/add_category_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/category/delete_category_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/category/get_all_categories_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/category/category_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'category_bloc_test.mocks.dart';

@GenerateMocks([
  AddCategoryUseCase,
  GetAllCategoriesUseCase,
  DeleteCategoryUseCase,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CategoryBloc categoryBloc;
  late MockAddCategoryUseCase mockAddCategoryUseCase;
  late MockGetAllCategoriesUseCase mockGetAllCategoriesUseCase;
  late MockDeleteCategoryUseCase mockDeleteCategoryUseCase;

  setUp(() {
    mockAddCategoryUseCase = MockAddCategoryUseCase();
    mockGetAllCategoriesUseCase = MockGetAllCategoriesUseCase();
    mockDeleteCategoryUseCase = MockDeleteCategoryUseCase();
    categoryBloc = CategoryBloc(
      mockAddCategoryUseCase,
      mockGetAllCategoriesUseCase,
      mockDeleteCategoryUseCase,
    );
  });

  tearDown(() {
    categoryBloc.close();
  });

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, success] when CategoryAddButtonClickedEvent is added and use case return success',
    build: () {
      when(mockAddCategoryUseCase.call(dummyFontCategoryType))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return categoryBloc;
    },
    act: (bloc) => bloc
        .add(CategoryAddButtonClickedEvent(category: dummyFontCategoryType)),
    expect: () => [
      CategoryState().copyWith(categoryAddStatus: BlocStatus.loading),
      CategoryState().copyWith(categoryAddStatus: BlocStatus.success),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, error, categoryAddMessage] when CategoryAddButtonClickedEvent is added and use case return failure',
    build: () {
      when(mockAddCategoryUseCase.call(dummyFontCategoryType))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return categoryBloc;
    },
    act: (bloc) => bloc
        .add(CategoryAddButtonClickedEvent(category: dummyFontCategoryType)),
    expect: () => [
      CategoryState().copyWith(categoryAddStatus: BlocStatus.loading),
      CategoryState().copyWith(
        categoryAddStatus: BlocStatus.error,
        categoryAddMessage: AppErrorMessages.categoryAlreadyAdded,
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, error, categoryAddMessage] when CategoryAddButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Add category failed',
      );
      when(mockAddCategoryUseCase.call(dummyFontCategoryType))
          .thenAnswer((_) async => Left(failure));

      return categoryBloc;
    },
    act: (bloc) => bloc
        .add(CategoryAddButtonClickedEvent(category: dummyFontCategoryType)),
    expect: () => [
      CategoryState().copyWith(categoryAddStatus: BlocStatus.loading),
      CategoryState().copyWith(
        categoryAddStatus: BlocStatus.error,
        categoryAddMessage: 'Add category failed',
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits updated state with categoryAddStatus, categoryAddMessage and category when SetCategoryAddStatusToDefault is added',
    build: () => categoryBloc,
    act: (bloc) => bloc.add(SetCategoryAddStatusToDefault()),
    expect: () => [
      CategoryState().copyWith(
        categoryAddStatus: BlocStatus.initial,
        categoryAddMessage: '',
        category: '',
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, success, listOfCategories] when GetAllCategoriesEvent is added and use case return list of categories',
    build: () {
      when(mockGetAllCategoriesUseCase.call(any))
          .thenAnswer((_) async => Right(dummyCategoryEntities));

      return categoryBloc;
    },
    act: (bloc) => bloc.add(GetAllCategoriesEvent()),
    expect: () => [
      CategoryState().copyWith(status: BlocStatus.loading),
      CategoryState().copyWith(
        status: BlocStatus.success,
        listOfCategories: dummyCategoryEntities,
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, error, message] when CategoryAddButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all categories failed',
      );
      when(mockGetAllCategoriesUseCase.call(any))
          .thenAnswer((_) async => Left(failure));

      return categoryBloc;
    },
    act: (bloc) => bloc.add(GetAllCategoriesEvent()),
    expect: () => [
      CategoryState().copyWith(status: BlocStatus.loading),
      CategoryState().copyWith(
        status: BlocStatus.error,
        message: 'Get all categories failed',
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, success] when DeleteCategoriesEvent is added and use case success',
    build: () {
      when(mockDeleteCategoryUseCase.call(fakeProductCategoryId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return categoryBloc;
    },
    act: (bloc) =>
        bloc.add(DeleteCategoriesEvent(categoryId: fakeProductCategoryId)),
    expect: () => [
      CategoryState().copyWith(status: BlocStatus.loading),
      CategoryState().copyWith(
        status: BlocStatus.success,
        isDeleted: true,
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [loading, error, message] when DeleteCategoriesEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Delete category failed',
      );
      when(mockDeleteCategoryUseCase.call(fakeProductCategoryId))
          .thenAnswer((_) async => Left(failure));

      return categoryBloc;
    },
    act: (bloc) =>
        bloc.add(DeleteCategoriesEvent(categoryId: fakeProductCategoryId)),
    expect: () => [
      CategoryState().copyWith(status: BlocStatus.loading),
      CategoryState().copyWith(
        status: BlocStatus.error,
        message: 'Delete category failed',
      ),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits updated state with isDeleted when SetDeleteStateToDefault is added',
    build: () => categoryBloc,
    act: (bloc) => bloc.add(SetDeleteStateToDefault()),
    expect: () => [
      CategoryState().copyWith(
        isDeleted: false,
      ),
    ],
  );
}
