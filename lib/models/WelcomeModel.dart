import 'package:travel_almaty/screens/Authentication/welcomeScreen.dart';

class welcomeModel{
  String img;
  String text;
  String desc;

  welcomeModel({
    required this.img,
    required this.text,
    required this.desc,
});
}

List<welcomeModel> screens = <welcomeModel>[
  welcomeModel(
    img: 'assets/welcome.png',
    text: "Город в кармане",
    desc:
    "Офлайн-гид по городу теперь всегда под рукой! Карта, интересные места,авторские маршруты и лайфхаки -ВСЁ включено!",
  ),
  welcomeModel(
      img: 'assets/routes.png',
      text: "Маршруты",
      desc:
      "Никаких типовых экскурсий: только авторские маршруты от людей, которые знают о городе больше чем Википедия."
  ),
  welcomeModel(
      img: 'assets/lifehack.png',
      text: "Лайфхаки",
      desc:
      "Бывалые путешественники подскажут, как получить от путешествия максимум удовольствия. И не наступить ни на одни грабли."
  ),

];