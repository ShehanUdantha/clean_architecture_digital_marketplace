part of 'admin_home_bloc.dart';

class AdminHomeState extends Equatable {
  final UserEntity userEntity;
  final Map<String, int> monthlyStatus;
  final int year;
  final int month;
  final bool isMonthlyStatusLoading;
  final double totalBalance;
  final double totalBalancePercentage;
  final List<ProductEntity> listOfTopSellingProduct;
  final BlocStatus monthlyTopSellingProductsListStatus;
  final String monthlyTopSellingProductsListMessage;

  const AdminHomeState({
    this.userEntity = const UserEntity(
      userId: '',
      userType: '',
      userName: '',
      email: '',
      password: '',
      deviceToken: '',
    ),
    this.monthlyStatus = const {},
    required this.year,
    required this.month,
    this.isMonthlyStatusLoading = false,
    this.totalBalance = 0.00,
    this.totalBalancePercentage = 0.0,
    this.listOfTopSellingProduct = const [],
    this.monthlyTopSellingProductsListStatus = BlocStatus.initial,
    this.monthlyTopSellingProductsListMessage = '',
  });

  AdminHomeState copyWith({
    UserEntity? userEntity,
    Map<String, int>? monthlyStatus,
    int? year,
    int? month,
    bool? isMonthlyStatusLoading,
    double? totalBalance,
    double? totalBalancePercentage,
    List<ProductEntity>? listOfTopSellingProduct,
    BlocStatus? monthlyTopSellingProductsListStatus,
    String? monthlyTopSellingProductsListMessage,
  }) =>
      AdminHomeState(
        userEntity: userEntity ?? this.userEntity,
        monthlyStatus: monthlyStatus ?? this.monthlyStatus,
        year: year ?? this.year,
        month: month ?? this.month,
        isMonthlyStatusLoading:
            isMonthlyStatusLoading ?? this.isMonthlyStatusLoading,
        totalBalance: totalBalance ?? this.totalBalance,
        totalBalancePercentage:
            totalBalancePercentage ?? this.totalBalancePercentage,
        listOfTopSellingProduct:
            listOfTopSellingProduct ?? this.listOfTopSellingProduct,
        monthlyTopSellingProductsListStatus:
            monthlyTopSellingProductsListStatus ??
                this.monthlyTopSellingProductsListStatus,
        monthlyTopSellingProductsListMessage:
            monthlyTopSellingProductsListMessage ??
                this.monthlyTopSellingProductsListMessage,
      );

  @override
  List<Object> get props => [
        userEntity,
        monthlyStatus,
        year,
        month,
        isMonthlyStatusLoading,
        totalBalance,
        totalBalancePercentage,
        listOfTopSellingProduct,
        monthlyTopSellingProductsListStatus,
        monthlyTopSellingProductsListMessage,
      ];
}
