
class SliderModel {
  String? image;
  String? name;
}

List<SliderModel> getSliders() {
  List<SliderModel> sliders = [];

  final sliderModelOne = SliderModel()
    ..name = "Model 1"
    ..image = "assets/img/business.png";

  final sliderModelTwo = SliderModel()
    ..name = "Model 2"
    ..image = "assets/img/business.png";

  final sliderModelThree = SliderModel()
    ..name = "Model 3"
    ..image = "assets/img/business.png";

  sliders = [sliderModelOne, sliderModelTwo, sliderModelThree];
  return sliders;
}
