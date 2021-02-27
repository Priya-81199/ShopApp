import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lilly_app/app/route.gr.dart' as rg;
import 'package:lilly_app/app/route.gr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


final storage = FirebaseStorage.instance;
final _auth = FirebaseAuth.instance;

User user = _auth.currentUser;

//Functions
String getImageURL(String imageName) {
  return 'https://firebasestorage.googleapis.com/v0/b/lillyapp-d0f89.appspot.com/o/product_images%2F${imageName}?alt=media';
}
void uploadPhotos(PlatformFile file) async{
  await storage.ref('product_images/${file.name}').putData(file.bytes);
}

launchWhatsApp() async {
  final link = WhatsAppUnilink(
    phoneNumber: '+91-9699893233',
    text: "Hey!",
  );
  await launch('$link');
}

//Constants
String adminEmail = 'princymishra10@gmail.com';


//Widgets


class ChatOptions extends StatelessWidget {
  const ChatOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green.shade600,
      child: FaIcon(FontAwesomeIcons.whatsapp),
      onPressed:(){
        launchWhatsApp();
      },
    );
  }
}


Widget getCard(BuildContext context,dynamic product, dynamic width, dynamic height){

  var nameFontSize = width / 232 * 18;
  var priceFontSize = width / 232 * 16;
  var descriptionFontSize = width / 232 * 12;
  return FlatButton(
    onPressed: () {
      ExtendedNavigator.of(context).push(Routes.productDetails,
          arguments: ProductDetailsArguments(product: product));
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        children: [
          Container(
              height: 0.65 * height,
              child: Image.network(getImageURL(product['images'][0]))),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              product['name'],
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              product['description'],
              style: TextStyle(
                fontFamily: 'Handlee',
                fontSize: descriptionFontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '₹' + product['price'],
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: priceFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.pinkAccent,
              ),
            ),
          ),
        ],
      ),
    ),
  );

}

AppBar buildAppBar(BuildContext context,Function() f) {
  return AppBar(
    backgroundColor: Color.fromRGBO(39, 102, 120, 1),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          hoverColor: Colors.transparent,
          onPressed: (){
            ExtendedNavigator.of(context).push(rg.Routes.homePage);
          },
          child: Text(
            'Lilly',
            style: TextStyle(
              fontFamily: 'Lobster',
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          child: FutureBuilder(
            future: FlutterSession().get('isUserSet'),
            builder: (context, snapshot) {
              return Container(
                child: Row(
                  children: [
                    snapshot.hasData ?
                    ((snapshot.data) && (user.email != adminEmail))?
                        Tooltip(
                          message: 'My Cart',
                          child: IconButton(
                              hoverColor: Colors.transparent,
                            icon: Icon(Icons.shopping_cart_rounded),
                            onPressed: (){
                              ExtendedNavigator.of(context).push(Routes.cart);
                            }
                          ),
                        ):
                        Container():
                      Container(),
                    snapshot.hasData ?
                    ((snapshot.data) && (user.email != adminEmail))?
                    Tooltip(
                      message:'My Orders',
                      child: IconButton(
                          hoverColor: Colors.transparent,
                          icon: Icon(Icons.shopping_bag_rounded),
                          onPressed: (){
                            ExtendedNavigator.of(context).push(Routes.orders);
                          }
                      ),
                    ):
                    Container():
                    Container(),
                    Container(
                      width: 150,
                      height: 100,
                      child: FlatButton(
                        hoverColor: Color.fromRGBO(211, 224, 234, 1),
                        child: Text(
                          snapshot.hasData ?
                            snapshot.data ?
                              'Logout' :
                              'Login' :
                            'Loading',
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () async {
                          if (snapshot.hasData) {
                            if (snapshot.data) {
                              FirebaseAuth.instance.signOut();
                              await FlutterSession().set('isUserSet', false);
                              ExtendedNavigator.of(context).push(rg.Routes.homePage);
                              f();
                            } else {
                              ExtendedNavigator.of(context).push(rg.Routes.loginScreen);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
const kSendButtonTextStyle = TextStyle(
  color: Colors.indigo,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(color: Colors.white),
  border: InputBorder.none,
);
const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.indigoAccent, width: 2.0),
  ),
);
const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.indigo),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigo, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
