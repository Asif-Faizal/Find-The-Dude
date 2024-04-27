import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ImageEvent {}

class LoadImagesEvent extends ImageEvent {}

class ImageState {}

class ImageLoadedState extends ImageState {
  final List<String> imageUrls;

  ImageLoadedState({required this.imageUrls});
}

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageState());

  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is LoadImagesEvent) {
      yield* _loadImages();
    }
  }

  Stream<ImageState> _loadImages() async* {
    final response =
        await http.get(Uri.parse('http://localhost:300/api/upload'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final imageUrls = jsonData.map((image) => image['imageUrl']).toList();

      yield ImageLoadedState(imageUrls: imageUrls);
    } else {
      //show snackBar
    }
  }
}
