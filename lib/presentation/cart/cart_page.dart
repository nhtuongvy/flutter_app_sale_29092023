import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/common/base/base_widget.dart';
import 'package:flutter_app_sale_29092023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/model/cart.dart';
import 'package:flutter_app_sale_29092023/data/model/product.dart';
import 'package:flutter_app_sale_29092023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_29092023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/cart/cart_bloc.dart';
import 'package:flutter_app_sale_29092023/presentation/product/product_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => ApiService()),
        // ProxyProvider<ApiService, ProductRepository>(
        //   create: (context) => ProductRepository(),
        //   update: (_, request, repository) {
        //     repository ??= ProductRepository();
        //     repository.setApiService(request);
        //     return repository;
        //   },
        // ),
        ProxyProvider<ApiService, CartRepository>(
          create: (context) => CartRepository(),
          update: (_, request, repository) {
            repository ??= CartRepository();
            repository.setApiService(request);
            return repository;
          },
        ),
        ProxyProvider2<ProductRepository, CartRepository, ProductBloc>(
          create: (context) => ProductBloc(),
          update: (_, productRepo, cartRepo, bloc) {
            bloc?.setProductRepo(productRepo);
            bloc?.setCartRepo(cartRepo);
            return bloc ?? ProductBloc();
          },
        )
      ],
      child: CartContainer(),
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {},
        ),
        actions: [
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.history)),
          ),
          SizedBox(width: 10),
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.shopping_cart_outlined)),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class CartContainer extends StatefulWidget {
  const CartContainer({super.key});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  CartBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc?.getCartProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: StreamBuilder<Cart>(
              initialData: Cart(),
              stream: _bloc?.getCartStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data?.listProduct.isEmpty == true) {
                  return Container(
                    child: Center(child: Text("Data empty")),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.listProduct.length ?? 0,
                    itemBuilder: (context, index) {
                      var itemProduct = snapshot.data?.listProduct[index];
                      return _buildItemFood(itemProduct);
                    }
                );
              }
          ),
        ),
        LoadingWidget(bloc: _bloc),
      ],
    );
  }

  Widget _buildItemFood(Product? product) {
    if (product == null) return Container();
    return SizedBox(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(AppConstant.BASE_URL + product.img,
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text(
                          "Giá : ${NumberFormat("#,###", "en_US")
                              .format(product.price)} đ",
                          style: const TextStyle(fontSize: 12)),
                      TextField(
                        controller: new TextEditingController(text: product.toString()),
                        decoration: new InputDecoration(labelText: "Quantity"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}