import 'package:Pixelcart/src/core/constants/error_messages.dart';
import 'package:Pixelcart/src/core/error/failure.dart';
import 'package:Pixelcart/src/core/utils/enum.dart';
import 'package:Pixelcart/src/core/utils/extension.dart';
import 'package:Pixelcart/src/domain/usecases/product/add_product_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/delete_product_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/edit_product_usecase.dart';
import 'package:Pixelcart/src/domain/usecases/product/get_all_products_usecase.dart';
import 'package:Pixelcart/src/presentation/blocs/product/product_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/constant_values.dart';
import 'product_bloc_test.mocks.dart';

@GenerateMocks([
  AddProductUseCase,
  EditProductUseCase,
  GetAllProductsUseCase,
  DeleteProductUseCase,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProductBloc productBloc;
  late MockAddProductUseCase mockAddProductUseCase;
  late MockEditProductUseCase mockEditProductUseCase;
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;
  late MockDeleteProductUseCase mockDeleteProductUseCase;

  setUp(() {
    mockAddProductUseCase = MockAddProductUseCase();
    mockEditProductUseCase = MockEditProductUseCase();
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    mockDeleteProductUseCase = MockDeleteProductUseCase();
    productBloc = ProductBloc(
      mockAddProductUseCase,
      mockEditProductUseCase,
      mockGetAllProductsUseCase,
      mockDeleteProductUseCase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  blocTest<ProductBloc, ProductState>(
    'emits updated state with category when CategoryNameFieldChangeEvent is added',
    build: () => productBloc,
    act: (bloc) =>
        bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType)),
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits updated state with marketingType when MarketingTypeFieldChangeEvent is added',
    build: () => productBloc,
    act: (bloc) =>
        bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType)),
    expect: () => [
      ProductState().copyWith(
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, success] when ProductUploadButtonClickedEvent is added and use case return success',
    build: () {
      when(mockAddProductUseCase.call(dummyNewProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductUploadButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: newProductDescription,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.success,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, error, productAddAndEditMessage] when ProductUploadButtonClickedEvent is added and use case return failure',
    build: () {
      when(mockAddProductUseCase.call(dummyNewProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductUploadButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: newProductDescription,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditMessage: AppErrorMessages.productAlreadyAdded,
        productAddAndEditStatus: BlocStatus.error,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, error, productAddAndEditMessage] when ProductUploadButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Add product to DB failed',
      );
      when(mockAddProductUseCase.call(dummyNewProductEntity))
          .thenAnswer((_) async => Left(failure));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductUploadButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: newProductDescription,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditMessage: 'Add product to DB failed',
        productAddAndEditStatus: BlocStatus.error,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, success] when ProductEditButtonClickedEvent is added and use case return success',
    build: () {
      when(mockEditProductUseCase.call(dummyEditProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductEditButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          id: editProductId,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: editProductDescription,
          likes: [],
          status: editProductStatus,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.success,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, error, productAddAndEditMessage] when ProductEditButtonClickedEvent is added and use case return failure',
    build: () {
      when(mockEditProductUseCase.call(dummyEditProductEntity))
          .thenAnswer((_) async => Right(ResponseTypes.failure.response));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductEditButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          id: editProductId,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: editProductDescription,
          likes: [],
          status: editProductStatus,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditMessage: AppErrorMessages.productIdNotFound,
        productAddAndEditStatus: BlocStatus.error,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [category, marketingType, loading, error, productAddAndEditMessage] when ProductEditButtonClickedEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Product edit failed',
      );
      when(mockEditProductUseCase.call(dummyEditProductEntity))
          .thenAnswer((_) async => Left(failure));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(CategoryNameFieldChangeEvent(category: dummyFontCategoryType));
      bloc.add(MarketingTypeFieldChangeEvent(type: dummyMarketingType));
      bloc.add(
        ProductEditButtonClickedEvent(
          coverImage: null,
          subImages: [],
          zipFile: null,
          id: editProductId,
          productName: newProductName,
          productPrice: newProductPrice,
          productDescription: editProductDescription,
          likes: [],
          status: editProductStatus,
        ),
      );
    },
    expect: () => [
      ProductState().copyWith(
        category: dummyFontCategoryType,
      ),
      ProductState().copyWith(
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.loading,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
      ProductState().copyWith(
        productAddAndEditMessage: 'Product edit failed',
        productAddAndEditStatus: BlocStatus.error,
        category: dummyFontCategoryType,
        marketingType: dummyMarketingType,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits updated state with productAddAndEditStatus and productAddAndEditMessage when SetProductFavoriteToDefaultEvent is added',
    build: () => productBloc,
    act: (bloc) => bloc.add(SetProductAddAndEditStatusToDefault()),
    expect: () => [
      ProductState().copyWith(
        productAddAndEditStatus: BlocStatus.initial,
        productAddAndEditMessage: '',
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits updated state with currentCategoryId and currentCategoryName when CategorySelectEvent is added',
    build: () => productBloc,
    act: (bloc) => bloc.add(
      CategorySelectEvent(
        value: categoryTypeIdForFonts,
        name: categoryTypeFonts,
      ),
    ),
    expect: () => [
      ProductState().copyWith(
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [currentCategory, currentCategoryName, loading, success, listOfProducts] when GetAllProductsEvent is added and use case return list of products',
    build: () {
      when(mockGetAllProductsUseCase.call(categoryTypeFonts))
          .thenAnswer((_) async => Right(dummyFontsCategoryProductEntities));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(
        CategorySelectEvent(
          value: categoryTypeIdForFonts,
          name: categoryTypeFonts,
        ),
      );
      bloc.add(GetAllProductsEvent());
    },
    expect: () => [
      ProductState().copyWith(
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
      ),
      ProductState().copyWith(
        status: BlocStatus.loading,
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
      ),
      ProductState().copyWith(
        status: BlocStatus.success,
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
        listOfProducts: dummyFontsCategoryProductEntities,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [currentCategory, currentCategoryName, loading, error, message] when GetAllProductsEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Get all products by category name failed',
      );
      when(mockGetAllProductsUseCase.call(categoryTypeFonts))
          .thenAnswer((_) async => Left(failure));

      return productBloc;
    },
    act: (bloc) {
      bloc.add(
        CategorySelectEvent(
          value: categoryTypeIdForFonts,
          name: categoryTypeFonts,
        ),
      );
      bloc.add(GetAllProductsEvent());
    },
    expect: () => [
      ProductState().copyWith(
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
      ),
      ProductState().copyWith(
        status: BlocStatus.loading,
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
      ),
      ProductState().copyWith(
        status: BlocStatus.error,
        currentCategory: categoryTypeIdForFonts,
        currentCategoryName: categoryTypeFonts,
        message: 'Get all products by category name failed',
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [loading, success, isDeleted] when ProductDeleteEvent is added and use case return success',
    build: () {
      when(mockDeleteProductUseCase.call(fakeProductId))
          .thenAnswer((_) async => Right(ResponseTypes.success.response));

      return productBloc;
    },
    act: (bloc) => bloc.add(ProductDeleteEvent(productId: fakeProductId)),
    expect: () => [
      ProductState().copyWith(status: BlocStatus.loading),
      ProductState().copyWith(
        status: BlocStatus.success,
        isDeleted: true,
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits [loading, error, message] when ProductDeleteEvent fails',
    build: () {
      final failure = FirebaseFailure(
        errorMessage: 'Product delete failed',
      );
      when(mockDeleteProductUseCase.call(fakeProductId))
          .thenAnswer((_) async => Left(failure));

      return productBloc;
    },
    act: (bloc) => bloc.add(ProductDeleteEvent(productId: fakeProductId)),
    expect: () => [
      ProductState().copyWith(status: BlocStatus.loading),
      ProductState().copyWith(
        status: BlocStatus.error,
        message: 'Product delete failed',
      ),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'emits updated state with isDeleted when SetProductDeleteStateToDefault is added',
    build: () => productBloc,
    act: (bloc) => bloc.add(SetProductDeleteStateToDefault()),
    expect: () => [
      ProductState().copyWith(
        isDeleted: false,
      ),
    ],
  );
}
