import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_app_sale_29092023/common/app_constant.dart';
import 'package:flutter_app_sale_29092023/common/base/base_widget.dart';
import 'package:flutter_app_sale_29092023/common/widget/loading_widget.dart';
import 'package:flutter_app_sale_29092023/data/api/api_service.dart';
import 'package:flutter_app_sale_29092023/data/model/cart.dart';
import 'package:flutter_app_sale_29092023/data/model/product.dart';
import 'package:flutter_app_sale_29092023/data/repository/cart_repository.dart';
import 'package:flutter_app_sale_29092023/data/repository/product_repository.dart';
import 'package:flutter_app_sale_29092023/presentation/product/product_bloc.dart';
import 'package:flutter_app_sale_29092023/presentation/product/product_event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      providers: [
        Provider(create: (context) => ApiService()),
        ProxyProvider<ApiService, ProductRepository>(
          create: (context) => ProductRepository(),
          update: (_, request, repository) {
            repository ??= ProductRepository();
            repository.setApiService(request);
            return repository;
          },
        ),
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
      child: ProductContainer(),
      appBar: AppBar(
        title: const Text("Products"),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {},
        ),
        actions: [
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.history)),
          )
          ,
          SizedBox(width: 10),
          Center(
            child: Consumer<ProductBloc>(
              builder: (context, bloc, child){
                return StreamBuilder<Cart>(
                    initialData: null,
                    stream: bloc.getCartStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || snapshot.data == null || snapshot.data?.listProduct.isEmpty == true) {
                        return InkWell(
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: Icon(Icons.shopping_cart_outlined),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, "/cart");
                                },
                              )
                          ),
                        );
                      }
                      int count = 0;
                      snapshot.data?.listProduct.forEach((element) {
                        count += element.quantity.toInt();
                      });
                      return Container(
                        margin: EdgeInsets.only(right: 10),
                        child: badges.Badge(
                          badgeContent: Text(count.toString(), style: const TextStyle(color: Colors.white),),
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/cart");
                            },
                          )
                        ),
                      );
                    }
                );
              },
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class ProductContainer extends StatefulWidget {
  const ProductContainer({super.key});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {

  ProductBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc?.getListProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: StreamBuilder<List<Product>>(
              initialData: const [],
              stream: _bloc?.getListProductStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data?.isEmpty == true) {
                  return Container(
                    child: Center(child: Text("Data empty")),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var itemProduct = snapshot.data?[index];
                      return _buildItemFood(itemProduct, () {
                        _bloc?.eventSink.add(AddToCartEvent(itemProduct?.id ?? ""));
                      });
                    }
                );
              }
          ),
        ),
        LoadingWidget(bloc: _bloc),
      ],
    );
  }

  Widget _buildItemFood(Product? product, Function()? eventAddCart) {
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
                      Row(
                          children:[
                            ElevatedButton(
                              onPressed: eventAddCart,
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(200, 240, 102, 61);
                                    } else {
                                      return const Color.fromARGB(230, 240, 102, 61);
                                    }
                                  }),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))))),
                              child:
                              const Text("Thêm vào giỏ", style: TextStyle(fontSize: 14)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ElevatedButton(
                                onPressed: () {
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return const Color.fromARGB(200, 11, 22, 142);
                                      } else {
                                        return const Color.fromARGB(230, 11, 22, 142);
                                      }
                                    }),
                                    shape: MaterialStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))))),
                                child:
                                Text("Chi tiết", style: const TextStyle(fontSize: 14)),
                              ),
                            ),
                          ]
                      ),
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

