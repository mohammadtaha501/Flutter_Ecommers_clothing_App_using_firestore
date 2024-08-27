import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'item_details_screen.dart';

class Item {
  final name;
  final List<String> imageUrl;
  final price;
  final documentId;
  final category;
  final description;

  Item(  {
    required this.documentId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
  });

  factory Item.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> downloadUrls = [];
    data.forEach((key, value) {
      if (key.startsWith('downloadUrl') && value is String) {
        downloadUrls.add(value);
          }
        }
      );
    return Item(
      documentId: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0.0,
      category: data['category'] ?? '',
      description: data['description'] ?? 'no description',
      imageUrl: downloadUrls,
    );
  }
}

class cardView extends StatelessWidget {
  final Item item;
  const cardView({
    super.key,
    required this.item
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
              child: Image.network(
                  item.imageUrl[0],
                  fit: BoxFit.cover
              )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Rs${item.price}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class ItemGrid extends StatefulWidget {
  final Query query;

  const ItemGrid({super.key, required this.query});
  @override
  State<ItemGrid> createState() => _ItemGridState();
}

class _ItemGridState extends State<ItemGrid> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:widget.query.snapshots(),
      //FirebaseFirestore.instance.collection('items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Lottie.asset('assets/loading.json', width: 200, height: 200),);
        }

        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items found'));
        }
        else if(snapshot.hasData) {
          final items = snapshot.data!.docs.map((doc) {
            return Item.fromDocument(doc);
          }).toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio: 3 / 4, // Aspect ratio of each item
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(item: items[index]),
                    ),
                  );
                },
                  child: cardView(item: items[index])
              );
            },
          );
        }
        else{
          return const Text('something went wrong');
        }
      },
    );
  }
}
/// bloc handling
@immutable
abstract class appState{
  final Query query;
  final String? gender;
  final String? categery;

  appState({required this.query, required this.gender, required this.categery});

}

class InitialState extends appState{

  InitialState({
    required super.query,
  }):super(
    gender: null,
    categery: null,
  );
}

class GentsTshirt extends appState{

  GentsTshirt({
    required super.query,
    required super.gender,
    required super.categery});
}

class LadiesTshirt extends appState{

  LadiesTshirt({
    required super.query,
    required super.gender,
    required super.categery});
}

class GentsJeans extends appState{

  GentsJeans({
    required super.query,
    required super.gender,
    required super.categery});
}

class LadiesJeans extends appState{

  LadiesJeans({
    required super.query,
    required super.gender,
    required super.categery});
}

class ChangerGender extends appState{

  ChangerGender({
    required super.query,
    required super.gender,
    required super.categery});
}

class ChangerCatigory extends appState{

  ChangerCatigory({
    required super.query,
    required super.gender,
    required super.categery});
}

@immutable
abstract class appEvent{
  final String? gender;
  final String? categery;
  const appEvent({
    required this.gender,
    required this.categery});
}

class GentsTshirtEvent extends appEvent{//going on
  const GentsTshirtEvent({required super.gender, required super.categery});
}

class LadiesTshirtEvent extends appEvent{//done
  const LadiesTshirtEvent({required super.gender, required super.categery});
}

class GentsJeansEvent extends appEvent{//done
  const GentsJeansEvent({required super.gender, required super.categery});
}

class LadiesJeansEvent extends appEvent{//done
  const LadiesJeansEvent({required super.gender, required super.categery});
}

class ChangerGenderEvent extends appEvent{//done
  const ChangerGenderEvent({required super.gender, required super.categery});
}

class ChangerCatigoryEvent extends appEvent{//done
    const ChangerCatigoryEvent({required super.gender, required super.categery});
}

class BlocClass extends Bloc<appEvent,appState>{
  final Query query;
  BlocClass(this.query):super(InitialState(query: query)){
  on<ChangerGenderEvent>((event, emit) {
    Query query;
    if(event.categery==null){
      query=FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: event.gender);
    }else if(event.categery=='null'){
      if(state.categery!=null){
        query=FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: event.gender).where('category', isEqualTo:state.categery );
      }else{
        query=FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: event.gender);
      }
    }else{
      query=FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: event.gender).where('category', isEqualTo:state.categery );
    }
    emit(
        ChangerGender(
          query: query,
          categery: state.categery,
          gender: event.gender,
        )
    );
      },
    );

  on<ChangerCatigoryEvent>((event, emit) {
    Query query;
    if(event.gender==null){
      query=FirebaseFirestore.instance.collection('items').where('category', isEqualTo:event.categery );
    }else{//when categery is Jeans
      query=FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: state.gender).where('category', isEqualTo:event.categery );
    }
    emit(
      ChangerCatigory(query: query, gender: state.gender, categery: event.categery)
    );
    },
  );

  on<LadiesJeansEvent>((event, emit) => emit(
    LadiesJeans(query: FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: 'female').where('category', isEqualTo:'Jeans' ),
        gender: 'female',
        categery: 'Jeans')
      ),
    );

  on<GentsJeansEvent>((event, emit) => emit(
      LadiesJeans(query: FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: 'male').where('category', isEqualTo:'Jeans' ),
          gender: 'male',
          categery: 'Jeans')
     ),
   );

  on<LadiesTshirtEvent>((event, emit) => emit(
      LadiesTshirt(query: FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: 'female').where('category', isEqualTo:'Tshirt' ),
          gender: 'female',
          categery: 'Tshirt')
      ),
    );

  on<GentsTshirtEvent>((event, emit) => emit(
      GentsTshirt(query: FirebaseFirestore.instance.collection('items').where('gender', isEqualTo: 'male').where('category', isEqualTo:'Tshirt' ),
          gender: 'male',
          categery: 'Tshirt')
      ),
    );
  }
}
/// UI
class GalleryView extends StatefulWidget {
  const GalleryView({super.key});
  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  int _currentIndex = 0;
  final Query query = FirebaseFirestore.instance.collection('items');
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => BlocClass(query),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF800000),
          automaticallyImplyLeading: false,
          title: const Text('Main Menu'),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: BlocBuilder<BlocClass,appState>(
          builder: (context, state) => Drawer(
            backgroundColor: const Color(0xFFB33333),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                color: const Color(0xFF800000),
                height: 100,
                  child: const DrawerHeader(
                      margin: EdgeInsets.zero,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                        ),
                ),
                ListTile(
                  title: const Text('all Shirts'),
                  onTap: () {
                    context.read<BlocClass>().add(const ChangerCatigoryEvent(gender:null, categery:'Tshirt'));
                  },
                ),
                ListTile(
                  title: const Text('all Jeans'),
                  onTap: () {
                    context.read<BlocClass>().add(const ChangerCatigoryEvent(gender:null, categery:'Jeans'));
                  },
                ),
                ExpansionTile(
                  backgroundColor: const Color(0xFFB33333), // Background color when expanded
                  iconColor: Colors.white, // Color of the expand/collapse icon
                  textColor: Colors.white, // Text color of the title
                    title:const Text('Gents'),
                    children: [
                      ListTile(
                        title: const Text('Gents T-Shirt'),
                        onTap: () {
                          context.read<BlocClass>().add(const GentsTshirtEvent(gender:'male', categery:'Tshirt'));
                          },
                       ),
                      ListTile(
                        title: const Text('Gents Jeans'),
                        onTap: () {
                          context.read<BlocClass>().add(const GentsJeansEvent(gender:'male', categery:'Jeans'));
                        },
                      ),
                      ListTile(
                        title: const Text('All Gents Items'),
                        onTap: () {
                          context.read<BlocClass>().add(const ChangerGenderEvent(gender: 'male', categery: null));
                        },
                      ),
                    ],
                ),
                ExpansionTile(
                  title:const Text('Ladies'),
                  children: [
                    ListTile(
                      title: const Text('Ladies T-Shirt'),
                      onTap: () {
                        context.read<BlocClass>().add(const LadiesTshirtEvent(gender: 'female', categery: 'Tshirt'));
                      },
                    ),
                    ListTile(
                      title: const Text('Ladies Jeans'),
                      onTap: () {
                        context.read<BlocClass>().add(const LadiesJeansEvent(gender: 'female', categery: 'Jeans'));
                      },
                    ),
                    ListTile(
                      title: const Text('All Ladies Items'),
                      onTap: () {
                        context.read<BlocClass>().add(const ChangerGenderEvent(gender: 'female', categery: null));
                      },
                    ),
                  ],
                ),
              ],
            )
          ),

        ),
        body:BlocBuilder<BlocClass,appState>(
          builder: (context, state) {
            return ItemGrid(query: state.query);
          },
        ),
        bottomNavigationBar: BlocBuilder<BlocClass,appState>(
          builder: (context, state) => BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    if (index == 0) {
                      context.read<BlocClass>().add(
                          const ChangerGenderEvent(
                              categery: 'null', gender: 'female'));
                    } else if (index == 1) {
                      context.read<BlocClass>().add(
                          const ChangerGenderEvent(
                              categery: 'null', gender: 'male'));
                    }
                  }
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.woman),
                    label: 'Women',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.man),
                    label: 'Men',
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
