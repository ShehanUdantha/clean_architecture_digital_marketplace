// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import '../../../../core/utils/extension.dart';
import '../../../../core/utils/helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../domain/entities/product/product_entity.dart';
import '../../../../core/widgets/elevated_button_widget.dart';
import '../../../../core/widgets/elevated_loading_button_widget.dart';
import '../../../../core/widgets/input_field_widget.dart';
import '../../../../core/widgets/page_header_widget.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/lists.dart';
import '../../../../core/constants/routes_name.dart';
import '../../../../core/utils/enum.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../widgets/admin/tools/drop_down_widget.dart';
import '../../../widgets/admin/tools/sub_image_chip_widget.dart';
import '../../../widgets/admin/tools/sub_images_add_button_widget.dart';
import '../../../widgets/admin/tools/upload_cover_image_widget.dart';

class ProductAddEditPage extends StatefulWidget {
  final String title;
  final ProductEntity? product;

  const ProductAddEditPage({
    super.key,
    required this.title,
    this.product,
  });

  @override
  State<ProductAddEditPage> createState() => _ProductAddEditPageState();
}

class _ProductAddEditPageState extends State<ProductAddEditPage> {
  PlatformFile? coverImage;
  List<PlatformFile>? subImages;
  PlatformFile? asset;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  String? sharedCategoryDropDownValue;
  String? sharedMarketingTypeDropDownValue;
  bool isUploadAssetsAvailableInSharedProduct = false;
  String? sharedCoverImage;
  List<String>? sharedSubImages;

  @override
  void initState() {
    _initProductAddAndEditPage();
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  _bodyWidget() {
    final headerName = widget.title == CURDTypes.add.name
        ? context.loc.add
        : context.loc.update;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: BlocConsumer<ProductBloc, ProductState>(
            listenWhen: (previous, current) =>
                previous.productAddAndEditStatus !=
                current.productAddAndEditStatus,
            listener: (context, state) {
              if (state.productAddAndEditStatus == BlocStatus.error) {
                context
                    .read<ProductBloc>()
                    .add(SetProductAddAndEditStatusToDefault());
                Helper.showSnackBar(
                  context,
                  state.productAddAndEditMessage ==
                          ResponseTypes.failure.response
                      ? context.loc.productAlreadyAdded
                      : state.productAddAndEditMessage,
                );
              }
              if (state.productAddAndEditStatus == BlocStatus.success) {
                context
                    .read<ProductBloc>()
                    .add(SetProductAddAndEditStatusToDefault());

                Helper.showSnackBar(
                  context,
                  widget.title == CURDTypes.update.name
                      ? context.loc.productUpdated
                      : context.loc.productAdded,
                );

                context.read<ProductBloc>().add(GetAllProductsEvent());

                context.goNamed(AppRoutes.productsManagePageName);
              }
            },
            buildWhen: (previous, current) =>
                previous.productAddAndEditStatus !=
                current.productAddAndEditStatus,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageHeaderWidget(
                    title: '$headerName ${context.loc.product}',
                    function: () => _handleBackButton(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => state.productAddAndEditStatus ==
                                  BlocStatus.loading
                              ? () {}
                              : _handleSelectCoverImage(),
                          child: UploadCoverImageWidget(
                            coverImage: coverImage,
                            sharedCoverImage: sharedCoverImage,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          context.loc.uploadSubImages,
                          style: const TextStyle(
                            color: AppColors.textThird,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: Helper.isLandscape(context)
                              ? Helper.screeHeight(context) * 0.2
                              : Helper.screeHeight(context) * 0.1,
                          width: Helper.screeWidth(context),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => state.productAddAndEditStatus ==
                                        BlocStatus.loading
                                    ? () {}
                                    : _handleSelectSubImages(),
                                child: const SubImagesAddButtonWidget(),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              subImages != null || sharedSubImages != null
                                  ? Expanded(
                                      child: Row(
                                        children: [
                                          // newly added sub images list
                                          subImages != null
                                              ? subImages!.isNotEmpty
                                                  ? Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            subImages!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return SubImageChipWidget(
                                                            subImage:
                                                                subImages![
                                                                        index]
                                                                    .path,
                                                            isFiles: true,
                                                            removeFunction: () => state
                                                                        .productAddAndEditStatus ==
                                                                    BlocStatus
                                                                        .loading
                                                                ? () {}
                                                                : _handleSelectedSubImageRemove(
                                                                    subImages![
                                                                        index]),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox()
                                              : const SizedBox(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          // already exist sub images list - in firestore
                                          sharedSubImages != null
                                              ? sharedSubImages!.isNotEmpty
                                                  ? Expanded(
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            sharedSubImages!
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return SubImageChipWidget(
                                                            subImage:
                                                                sharedSubImages![
                                                                    index],
                                                            isFiles: false,
                                                            removeFunction: () => state
                                                                        .productAddAndEditStatus ==
                                                                    BlocStatus
                                                                        .loading
                                                                ? () {}
                                                                : _handleSharedSubImageRemove(
                                                                    sharedSubImages![
                                                                        index]),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox()
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        InputFieldWidget(
                          controller: _productNameController,
                          hint: context.loc.productName,
                          prefix: const Icon(Iconsax.bag_2),
                          isReadOnly: state.productAddAndEditStatus ==
                              BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        InputFieldWidget(
                          controller: _productPriceController,
                          hint: context.loc.price,
                          prefix: const Icon(Iconsax.dollar_circle),
                          keyBoardType: TextInputType.number,
                          isReadOnly: state.productAddAndEditStatus ==
                              BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropDownWidget(
                          value: sharedCategoryDropDownValue ?? '0',
                          items: _createProductCategoryList(context),
                          function: (value) => _handleCategoryDropDown(value),
                          isReadOnly: state.productAddAndEditStatus ==
                              BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropDownWidget(
                          value: sharedMarketingTypeDropDownValue ?? '0',
                          items: _createMarketingList(context),
                          function: (value) => _handleMarketingDropDown(value),
                          isReadOnly: state.productAddAndEditStatus ==
                              BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        InputFieldWidget(
                          controller: _productDescriptionController,
                          hint: context.loc.productDescription,
                          prefix: const Icon(Iconsax.card_edit),
                          isTextArea: true,
                          areaSize: 5,
                          isReadOnly: state.productAddAndEditStatus ==
                              BlocStatus.loading,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => state.productAddAndEditStatus ==
                                      BlocStatus.loading
                                  ? () {}
                                  : _handleUploadAsset(),
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  AppColors.textPrimary,
                                ),
                              ),
                              child: Text(
                                context.loc.uploadAsset,
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: Helper.isLandscape(context)
                                  ? Helper.screeWidth(context) * 0.75
                                  : Helper.screeWidth(context) * 0.55,
                              child: asset != null
                                  ? Text(
                                      asset!.name,
                                      style: const TextStyle(
                                        color: AppColors.textThird,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      isUploadAssetsAvailableInSharedProduct
                                          ? context.loc.assetAvailable
                                          : context.loc.noFileSelected,
                                      style: const TextStyle(
                                        color: AppColors.textThird,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  state.productAddAndEditStatus == BlocStatus.loading
                      ? const ElevatedLoadingButtonWidget()
                      : ElevatedButtonWidget(
                          title: '$headerName ${context.loc.product}',
                          function: () => _handleSubmitButton(),
                        ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _initProductAddAndEditPage() {
    if (widget.product != null && widget.title == CURDTypes.update.name) {
      final product = widget.product!;
      _productNameController.text = product.productName;
      _productPriceController.text = product.price;
      _productDescriptionController.text = product.description;

      sharedCategoryDropDownValue =
          _getSharedCategoryIndexFromList(context, product.category);
      sharedMarketingTypeDropDownValue =
          _getSharedMarketingIndexFromList(context, product.marketingType);

      context.read<ProductBloc>().add(
            CategoryNameFieldChangeEvent(
              category: product.category,
            ),
          );

      context.read<ProductBloc>().add(
            MarketingTypeFieldChangeEvent(
              type: product.marketingType,
            ),
          );

      isUploadAssetsAvailableInSharedProduct = product.zipFile != "";
      sharedCoverImage = product.coverImage;
      final List<String>? formattedSharedList =
          product.subImages?.map((e) => e.toString()).cast<String>().toList();
      sharedSubImages = formattedSharedList;

      setState(() {});
    }
  }

  _handleBackButton() {
    context.goNamed(AppRoutes.productsManagePageName);
  }

  _handleSelectCoverImage() async {
    final result = await Helper.imagePick();

    if (result != null) {
      setState(() {
        coverImage = result;
      });
    }
  }

  _handleSelectSubImages() async {
    final result = await Helper.multipleImagePick();

    if (result != null) {
      setState(() {
        subImages = result;
      });
    }
  }

  _handleSelectedSubImageRemove(PlatformFile? selectedFile) async {
    if (selectedFile == null) return;

    setState(() {
      subImages?.removeWhere((file) =>
          file.path == selectedFile.path || file.name == selectedFile.name);
    });
  }

  _handleSharedSubImageRemove(String? selectedImageUrl) async {
    if (selectedImageUrl == null) return;

    setState(() {
      sharedSubImages?.removeWhere((url) => url == selectedImageUrl);
    });
  }

  _handleCategoryDropDown(String value) {
    context.read<ProductBloc>().add(
          CategoryNameFieldChangeEvent(
            category: context
                .read<CategoryBloc>()
                .state
                .listOfCategories[int.parse(value) - 1]
                .name,
          ),
        );
  }

  _handleMarketingDropDown(String value) {
    context.read<ProductBloc>().add(
          MarketingTypeFieldChangeEvent(
            type: AppLists.listOfMarketingType[int.parse(value) - 1],
          ),
        );
  }

  _handleUploadAsset() async {
    final result = await Helper.zipFilePick();

    if (result != null) {
      setState(() {
        asset = result;
      });
    }
  }

  _handleSubmitButton() {
    final state = context.read<ProductBloc>().state;
    if (coverImage != null || sharedCoverImage != null) {
      if (subImages != null || sharedSubImages != null) {
        if (_productNameController.text.isNotEmpty) {
          if (_productPriceController.text.isNotEmpty) {
            if (state.category.isNotEmpty) {
              if (state.marketingType.isNotEmpty) {
                if (_productDescriptionController.text.isNotEmpty) {
                  if (asset != null || isUploadAssetsAvailableInSharedProduct) {
                    final getCurrentUserId =
                        context.read<AuthBloc>().currentUserId;

                    if (widget.product != null &&
                        widget.title == CURDTypes.update.name) {
                      final product = widget.product!;

                      context.read<ProductBloc>().add(
                            ProductEditButtonClickedEvent(
                              id: product.id!,
                              coverImage: coverImage?.bytes != null
                                  ? coverImage!.bytes
                                  : product.coverImage,
                              // newly added sub images list
                              subImages: subImages != null
                                  ? Helper.subImagesList(subImages!)
                                  : [],
                              zipFile: asset?.path != null
                                  ? File(asset!.path!)
                                  : product.zipFile,
                              productName: _productNameController.text,
                              productPrice: _productPriceController.text,
                              productDescription:
                                  _productDescriptionController.text,
                              // already exist sub images list - in firestore
                              sharedSubImages: sharedSubImages ?? [],
                              likes: product.likes,
                              status: product.status,
                              userId: getCurrentUserId ?? "-1",
                            ),
                          );
                    } else {
                      context.read<ProductBloc>().add(
                            ProductUploadButtonClickedEvent(
                              coverImage: coverImage!.bytes!,
                              subImages: Helper.subImagesList(subImages!),
                              zipFile: File(asset!.path!),
                              productName: _productNameController.text,
                              productPrice: _productPriceController.text,
                              productDescription:
                                  _productDescriptionController.text,
                              userId: getCurrentUserId ?? "-1",
                            ),
                          );
                    }
                  } else {
                    Helper.showSnackBar(context, context.loc.requiredZipFile);
                  }
                } else {
                  Helper.showSnackBar(context, context.loc.requiredDescription);
                }
              } else {
                Helper.showSnackBar(context, context.loc.requiredMarketingType);
              }
            } else {
              Helper.showSnackBar(context, context.loc.requiredCategory);
            }
          } else {
            Helper.showSnackBar(context, context.loc.requiredPrice);
          }
        } else {
          Helper.showSnackBar(context, context.loc.requiredProductName);
        }
      } else {
        Helper.showSnackBar(context, context.loc.requiredSubImages);
      }
    } else {
      Helper.showSnackBar(context, context.loc.requiredCoverImage);
    }
  }
}

List<DropdownMenuItem> _createProductCategoryList(BuildContext context) {
  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      value: '0',
      enabled: false,
      child: Row(
        children: [
          const Icon(
            Iconsax.category,
            color: AppColors.textThird,
          ),
          const SizedBox(
            width: 13,
          ),
          Text(
            context.loc.productCategory,
            style: const TextStyle(
              color: AppColors.textThird,
            ),
          ),
        ],
      ),
    ),
  ];
  final categoryState = context.read<CategoryBloc>().state;

  return items +
      (categoryState.listOfCategories.isNotEmpty
          ? Helper.createCategoryDropDownList(categoryState.listOfCategories)
          : []);
}

List<DropdownMenuItem> _createMarketingList(BuildContext context) {
  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      value: '0',
      enabled: false,
      child: Row(
        children: [
          const Icon(
            Iconsax.trend_up,
            color: AppColors.textThird,
          ),
          const SizedBox(
            width: 13,
          ),
          Text(
            context.loc.marketingType,
            style: const TextStyle(
              color: AppColors.textThird,
            ),
          ),
        ],
      ),
    ),
  ];

  return items + Helper.createMarketingDropDownList();
}

String _getSharedCategoryIndexFromList(
  BuildContext context,
  String category,
) {
  final categoryList = context.read<CategoryBloc>().state.listOfCategories;
  final index = categoryList.isNotEmpty
      ? categoryList.indexWhere((cat) => cat.name == category)
      : -1;

  if (index == -1) {
    return "0";
  } else {
    return (index + 1).toString();
  }
}

String _getSharedMarketingIndexFromList(
  BuildContext context,
  String marketingType,
) {
  final index =
      AppLists.listOfMarketingType.indexWhere((type) => type == marketingType);

  if (index == -1) {
    return "0";
  } else {
    return (index + 1).toString();
  }
}
