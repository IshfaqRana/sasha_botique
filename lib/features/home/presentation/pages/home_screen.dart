import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sasha_botique/core/extensions/get_text_style_extensions.dart';
import 'package:sasha_botique/features/theme/presentation/theme/theme_helper.dart';

import '../../../../core/di/injections.dart';
import '../../../../core/utils/product_category_enum.dart';
import '../../../../core/utils/product_category_mapper.dart';
import '../../../theme/presentation/bloc/theme_bloc.dart';
import '../../../theme/presentation/widget/theme_toggle_button.dart';
import '../bloc/home_bloc.dart';
import '../widgets/custom_drawar.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'product_list.dart';
import 'product_search_delegate.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final homeBloc = getIt<HomeBloc>();
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    homeBloc.add(LoadInitialProducts(ProductCategory.popular));
    homeBloc.add(LoadInitialProducts(ProductCategory.sale));
    homeBloc.add(LoadInitialProducts(ProductCategory.all));
    homeBloc.add(LoadInitialProducts(ProductCategory.newArrival));
    homeBloc.add(LoadInitialProducts(ProductCategory.gender,gender: "women"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text("SASHA'S",style: context.headlineMedium,),
        backgroundColor: context.colors.whiteColor,
        actions: [
          IconButton(
            icon:  Icon(Icons.notifications_outlined,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),
          // ThemeToggleButton(),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            }
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: context.titleSmall?.copyWith(color: context.colors.blackWhite),
          unselectedLabelStyle: context.titleSmall?.copyWith(color: context.colors.grey),
          tabs: const [
            Tab(text: 'Popular',),
            Tab(text: 'Brands'),
            Tab(text: 'Womens'),
            Tab(text: 'Sale'),
          ],
        ),
      ),
      endDrawer: const CustomDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: homeBloc,
        builder: (context, state) {
          print(state);
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(child: Text(state.message));
          }

          if (state is HomeLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.filter_list,),
                        label:  Text('FILTER & SORT',style: context.headlineSmall,),
                        onPressed: () {

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => FilterBottomSheet(
                                initialFilters: state.activeFilters,
                                currentSortOption: state.currentSortOption,
                                onApplyFilters: (filters, sortOption) {
                                  context.read<HomeBloc>().add(
                                    ApplyFilters(filters: filters, sortOption: sortOption),
                                  );
                                },
                              ),
                            );

                          // Show filter bottom sheet
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(state.isGridView
                            ? Icons.grid_view
                            : Icons.view_list
                        ),
                        onPressed: () {
                          homeBloc.add(
                              ToggleViewMode(!state.isGridView)
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ProductList(
                        products: state.categoryProducts[CategoryMapper.getCategory(ProductCategory.popular)] ?? [],
                        isGridView: state.isGridView,
                        onLoadMore: () => context.read<HomeBloc>().add(
                          LoadMoreProducts( ProductCategory.popular),
                        ),
                        onProductTap: (product) {},
                      ),
                      ProductList(
                        products: state.categoryProducts[CategoryMapper.getCategory(ProductCategory.newArrival)] ?? [],
                        isGridView: state.isGridView,
                        onLoadMore: () => context.read<HomeBloc>().add(
                          LoadMoreProducts( ProductCategory.newArrival),
                        ),
                        onProductTap: (product) {},
                      ),
                      ProductList(
                        products: state.categoryProducts[CategoryMapper.getCategory(ProductCategory.gender)] ?? [],
                        isGridView: state.isGridView,
                        onLoadMore: () => context.read<HomeBloc>().add(
                          LoadMoreProducts( ProductCategory.gender,gender: "women"),
                        ),
                        onProductTap: (product) {},
                      ),
                      ProductList(
                        products: state.categoryProducts[CategoryMapper.getCategory(ProductCategory.sale)] ?? [],
                        isGridView: state.isGridView,
                        onLoadMore: () => context.read<HomeBloc>().add(
                          LoadMoreProducts( ProductCategory.sale),
                        ),
                        onProductTap: (product) {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return   Center(child: Text("No state loaded"));
        },
      ),
    );
  }
}