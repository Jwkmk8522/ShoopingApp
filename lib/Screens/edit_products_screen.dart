import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shooping_app/Models/http_exceptions.dart';
import 'package:shooping_app/Providers/product.dart';
import 'package:shooping_app/Providers/products.dart';
import 'package:shooping_app/Utilities/error_dialog.dart';
import 'package:shooping_app/Widgets/Loading/new_card_skeleton.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/EditProducts';
  const EditProductsScreen({super.key});

  @override
  State<EditProductsScreen> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProductsScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _editedProduct = Product(
    imageUrl: '',
    id: '',
    title: '',
    description: '',
    price: 0,
  );

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;

// If id is not null mean user is to going for edit
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void customSnackBar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_editedProduct.id.isEmpty) {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);

        customSnackBar("Succesfully Added Product in User Product Screen");
      } else {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);

        customSnackBar("Succesfully Update Product");
      }
      Navigator.of(context).pop();
    } on NoInternetExceptions catch (error) {
      showErrorDialog(context, error.message);
    } on OnUnknownExceptions catch (error) {
      showErrorDialog(context, error.message);
    } catch (error) {
      showErrorDialog(context, "something went wrong");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Edit Products"),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) => const NewsCardSkelton(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ) // Prevents UI rendering when loading
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          hintText: 'Enter product title',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          prefixIcon: Icon(
                            Icons.title,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onError,
                                width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onError),
                        ),
                        textInputAction: TextInputAction.next,
                        // The color of the text that user enter
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Text';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: newValue,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          hintText: "Enter Product Price",
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          prefixIcon: Icon(
                            Icons.price_check_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onError,
                                width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onError),
                        ),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Price';
                          } else if (double.tryParse(value) == null) {
                            return 'Enter a valid Price ';
                          } else if (double.parse(value) <= 0) {
                            return 'Enter a price greter then 0';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: double.parse(newValue),
                                imageUrl: _editedProduct.imageUrl);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          hintText: "Enter Product Description",
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          prefixIcon: Icon(
                            Icons.description,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10)),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onError,
                                width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onError),
                        ),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Description';
                          } else if (value.length < 10) {
                            return 'Description should be atleast 10 characters';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null && newValue.isNotEmpty) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                                title: _editedProduct.title,
                                description: newValue,
                                price: _editedProduct.price,
                                imageUrl: _editedProduct.imageUrl);
                          }
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1.0)),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    "Enter Url ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: Text(
                                          "Enter valid Url",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onError),
                                        ));
                                      },
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                hintText: 'Enter the Url of Image',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(10)),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                      width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                errorStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
                              ),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              onChanged: (value) => setState(() {}),
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter ImageUrl';
                                } else if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return ' Please Enter a valid url';
                                } else if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please Enter a valid imag url';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                if (newValue != null && newValue.isNotEmpty) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: newValue,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
