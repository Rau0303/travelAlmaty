class myPlaces {
  late String title;
  late String subtitle;
  late String description;
  late List<String> ImageUrl;
  late double locationLatitude;
  late double locationLongitude;

  myPlaces({

    required this.title,
    required this.subtitle,
    required this.description,
    required this.ImageUrl,
    required this.locationLatitude,
    required this.locationLongitude});
}

List<myPlaces> myPlacesList = <myPlaces>[
  myPlaces(
      title: "Гора Кок Тобе",
      subtitle: "Kok-Tobe Hill",
      description:"Холм Кок-Тобе является популярной достопримечательностью Алматы, и одним из любимых мест отдыха горожан. Небольшая гора, название которой переводится как Зеленый холм." ,
      ImageUrl: ['myPlacesImages/koktobe_1.jpg','myPlacesImages/koktobe_2.jpg','myPlacesImages/koktobe_3.jpg','myPlacesImages/koktobe_4.png'],
      locationLatitude: 51.525375,
      locationLongitude: 77.467076,
  ),
  myPlaces(
    title: "Горнолыжный курорт Медеу",
    subtitle: "Medeu Scating Rink and Sci resort",
    description: "Крупнейший в мире высокогорный спортивный комплекс «Медеу» расположен в одноименном урочище Заилийского Алатау вблизи Алматы на высоте около 1700 метров над уровнем моря. От разрушительного воздействия селевых потоков «Медеу» защищает одноименная плотина, построенная в конце 1960-х годов и расположенная к югу от катка.",
    ImageUrl: ['myPlacesImages/medeu_1.jpg','myPlacesImages/medeu_2.jpg','myPlacesImages/medeu_3.jpg','myPlacesImages/medeu_4.jpg','myPlacesImages/medeu_5.jpg'],
    locationLatitude: 78.8732433,
    locationLongitude: 49.2500622,
  ),
  myPlaces(
    title: "Большое Алматинское озеро",
    subtitle: "Big Almaty Lake",
    description: "Большое Алматинское озеро, или сокращенно БАО – живописное озеро в 20 километрах от Алматы. Водоем находится рядом с госграницей Киргизии, однако для посещения не требуется специальных пропусков – и миллионы побывавших здесь туристов лучшее тому подтверждение.",
    ImageUrl: ['myPlacesImages/bao_1.jpg','myPlacesImages/bao_2.jpg','myPlacesImages/bao_3.jpg','myPlacesImages/bao_4.jpg','myPlacesImages/bao_5.jpg'],
    locationLatitude: 43.14239,
    locationLongitude: 77.00433,
  ),
  myPlaces(
    title: "Кольсайские озера",
    subtitle: "Kolsai Lakes",
    description: "Кольсайские озера – одно из красивейших мест казахской природы. Их еще называют голубым ожерельем Северного Тянь-Шаня. Оно и понятно – такую красоту встретишь не везде! В переводе с казахского языка ”кольсай” означает “озеро в ущелье”, потому что все три озера находятся в живописнейшем ущелье восточной части хребта Кунгей Алатау, что в 300 км от Алматы.",
    ImageUrl: ["myPlacesImages/kolsai_1.jpg","myPlacesImages/kolsai_2.jpg","myPlacesImages/kolsai_3.jpg","myPlacesImages/kolsai_4.jpg","myPlacesImages/kolsai_5.jpg"],
    locationLatitude: 42.934896,
    locationLongitude: 78.326468 ,
  ),
  myPlaces(
    title: "Шымбулак",
    subtitle: "Shymbulak Mountains",
    description: "Горнолыжный курорт «Шымбулак» – расположен в живописном ущелье Заилийского Алатау на высоте 2260 метров над уровнем моря, в 15 минутах езды от центра города Алматы.",
    ImageUrl: ['myPlacesImages/shymbulak_1.jpg','myPlacesImages/shymbulak_2.png','myPlacesImages/shymbulak_3.jpg','myPlacesImages/shymbulak_4.jpg'],
    locationLatitude: 43.1279984,
    locationLongitude: 43.1279984,
  ),
  myPlaces(
    title: "Чарынский каньон",
    subtitle: "Charyn",
    description: "Каньон Чарын расположен на территории Чарынского национального парка, созданного с целью сохранения природных и геологических объектов. Национальный парк был образован 23 февраля 2004 года. На территории парка обитает большое количество редких и исчезающих видов животных, занесенных в Красную книгу.",
    ImageUrl: ['myPlacesImages/charyn_1.jpg','myPlacesImages/charyn_2.jpg','myPlacesImages/charyn_3.jpg','myPlacesImages/charyn_4.jpg','myPlacesImages/charyn_5.jpg'],
    locationLatitude: 43.1279984,//Временнно
    locationLongitude: 43.1279984,
  ),
  myPlaces(
    title: "Бутоковский водопад",
    subtitle: "Butokov",
    description: "Бутаковский водопад — один из самых больших водопадов, расположенных рядом с городом Алматы. Находится, как не удивительно, в Бутаковском ущелье. Этот пост будет интересен тем, кто ещё не посетил данный водопад, а также, тем, кто не ищет лёгких путей. Я расскажу вам, как дойти до Бутаковского водопада от катка «Медео».",
    ImageUrl: ['myPlacesImages/butokov_1.jpg','myPlacesImages/butokov_2.jpeg'],
    locationLatitude: 43.172097,
    locationLongitude: 77.113623,
  ),
  myPlaces(
    title: "Алма-Арасан",
    subtitle: "Alma-Arasan",
    description: "Алма́-Араса́н — село и бальнеологический горный курорт в Карасайском районе Алматинской области Казахстана. Входит в состав Большеалматинского сельского округа. Находится в 26 км от Алма-Аты в одноименном ущелье Алма-Арасан, Заилийского Алатау, в живописной местности, на высоте 1800—1850 метров над уровнем моря.",
    ImageUrl: ['myPlacesImages/alma-arasan_1.jpg','myPlacesImages/alma-arasan_2.jpg','myPlacesImages/alma-arasan_3.jpg','myPlacesImages/alma-arasan_4.jpg'],
    locationLatitude: 43.0893912,
    locationLongitude: 76.90992500000002,
  ),


];