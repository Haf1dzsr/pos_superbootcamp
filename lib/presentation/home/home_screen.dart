import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/data/datasources/product_remote_datasource.dart';
import 'package:pos_superbootcamp/data/models/cart_model.dart';
import 'package:pos_superbootcamp/data/models/product_model.dart';
import 'package:pos_superbootcamp/data/utils/auth_helper.dart';
import 'package:pos_superbootcamp/presentation/app_route_names.dart';
import 'package:pos_superbootcamp/presentation/home/widgets/product_card_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColor.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.white,
                    child: Icon(
                      Icons.person,
                      color: AppColor.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser?.email ?? '',
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await AuthHelper.instance.deleteToken();
                await AuthHelper.instance.deleteUserId();
                FirebaseAuth.instance.signOut();
                context.pushReplacementNamed(AppRoutes.nrLogin);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          StreamBuilder<List<CartModel>>(
            stream: ProductRemoteDatasource.instance
                .getAllCartItemsByUserId(uid: currentUser!.uid),
            builder: (context, snapshot) {
              final cartItems = snapshot.data ?? [];
              return Badge(
                label: Text(cartItems.length.toString()),
                offset: const Offset(-10, 0),
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColor.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: AppColor.white,
                    ),
                    onPressed: () {
                      context.pushNamed(AppRoutes.nrCart);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<List<ProductModel>>(
            stream: ProductRemoteDatasource.instance
                .getProducts(uid: currentUser!.uid),
            builder: (context, snapshot) {
              final products = snapshot.data ?? [];
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: AppColor.error),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColor.primary),
                  ),
                );
              } else if (products.isEmpty) {
                return const Center(
                  child: Text('Belum ada produk'),
                );
              } else if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.8 / 2.4,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCardWidget(product: products[index]);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('Terjadi Kesalahan'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
