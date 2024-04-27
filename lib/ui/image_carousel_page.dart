import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alruism/blocs/image_bloc.dart';

class ImageShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ImageBloc>().add(LoadImagesEvent());
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.grey.shade200,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            size: 20,
            color: Colors.blue,
          ),
        ),
      ),
      child: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImageLoadedState) {
            return GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.imageUrls.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 2 + index)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () {
                          _showImageDialog(context, state.imageUrls[index]);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Stack(
                                children: [
                                  Image.network(
                                    state.imageUrls[index],
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        color: Colors.grey.shade200,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: Container(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator())));
          }
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
