import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// PODO class to represent our data
class AppData {
  final String logo;
  final String title;
  final String subtitle;
  final String formSubmitUrl;
  final List<FAQ> faq;
  final String footerNote;
  final List<String> carouselImages;

  AppData({
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.formSubmitUrl,
    required this.faq,
    required this.footerNote,
    required this.carouselImages,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      logo: json['logo'],
      title: json['title'],
      subtitle: json['subtitle'],
      formSubmitUrl: json['formSubmitUrl'],
      faq: (json['faq'] as List).map((item) => FAQ.fromJson(item)).toList(),
      footerNote: json['footerNote'],
      carouselImages: List<String>.from(json['carouselImages']),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradise Bagmati',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<AppData> futureAppData;

  @override
  void initState() {
    super.initState();
    futureAppData = fetchAppData();
  }

  Future<AppData> fetchAppData() async {
    // Simulating API call
    await Future.delayed(Duration(seconds: 1));
    final jsonString = '''
    {
      "logo": "assets/logo.png",
      "title": "Paradise Bagmati",
      "subtitle": "Discover Bagmati's Heritage",
      "formSubmitUrl": "https://kaha-api-test.masovison.com/api/v2/question",
      "faq": [
        {
          "question": "What is Paradise Bagmati?",
          "answer": "Paradise Bagmati is an app showcasing Sampada and Tourist Attractions in Bagmati Province, promoting tourism with digital preservation of heritage."
        },
        {
          "question": "What features does the app offer?",
          "answer": "The app includes a map, chat functionality, explore section, and text-to-speech for heritage details."
        }
      ],
      "footerNote": "Experience the beauty of Bagmati Province",
      "carouselImages": [
      "assets/1.jpg",
      "assets/2.jpg",
      "assets/3.jpg"
      ]
    }
    ''';
    return AppData.fromJson(json.decode(jsonString));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AppData>(
        future: futureAppData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ParadiseBagmatiUI(appData: snapshot.data!);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class ParadiseBagmatiUI extends StatelessWidget {
  final AppData appData;

  ParadiseBagmatiUI({required this.appData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 900;
      return Stack(
        children: [
          Positioned.fill(
            child: CarouselWithIndicator(
                showIndicator: false,
                fill: Colors.white54,
                images: appData.carouselImages),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: !isDesktop
                  ? Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                        scale: 1.4,
                                        child: Image.asset(appData.logo,
                                            height: 100)),
                                    SizedBox(height: 20),
                                    Text(appData.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge),
                                    Text(appData.subtitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    SizedBox(height: 20),
                                    Expanded(
                                        child: SupportForm(
                                            formSubmitUrl:
                                                appData.formSubmitUrl)),
                                    Text(appData.footerNote,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                        scale: 1.4,
                                        child: Image.asset(appData.logo,
                                            height: 100)),
                                    SizedBox(height: 20),
                                    Text(appData.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge),
                                    Text(appData.subtitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    SizedBox(height: 20),
                                    Expanded(
                                        child: SupportForm(
                                            formSubmitUrl:
                                                appData.formSubmitUrl)),
                                    Text(appData.footerNote,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(23),
                                  clipBehavior: Clip.antiAlias,
                                  child: CarouselWithIndicator(
                                      images: appData.carouselImages),
                                ),
                                Positioned(
                                  right: 16,
                                  top: 16,
                                  bottom: 16,
                                  width: 300,
                                  child: FAQList(faqs: appData.faq),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      );
    });
  }
}

class LoginForm extends StatefulWidget {
  final String formSubmitUrl;

  LoginForm({required this.formSubmitUrl});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Here you would typically send _email and _password to your backend
                print('Submitting to: ${widget.formSubmitUrl}');
                print('Email: $_email, Password: $_password');
              }
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  final List<String> images;

  CarouselWithIndicator(
      {required this.images,
      this.showIndicator = true,
      this.fill = Colors.black45});
  final bool showIndicator;
  Color fill;
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
          itemBuilder: (context, index) {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.fill,
                BlendMode.darken,
              ),
              child: Image.asset(
                widget.images[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        if (widget.showIndicator)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class FAQList extends StatelessWidget {
  final List<FAQ> faqs;

  FAQList({required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index].question),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faqs[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SupportForm extends StatefulWidget {
  final String formSubmitUrl;

  SupportForm({required this.formSubmitUrl});

  @override
  _SupportFormState createState() => _SupportFormState();
}

class _SupportFormState extends State<SupportForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _subject, _message;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Need Help? Contact Support',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                    onSaved: (value) => _subject = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                    onSaved: (value) => _message = value,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Prepare form data
                  final Map<String, dynamic> formData = {
                    'name': _name,
                    'email': _email,
                    'subject': _subject,
                    'message': _message,
                  };

                  // Create Dio instance
                  final dio = Dio();

                  // Set headers (optional)
                  dio.options.headers['Content-Type'] =
                      'application/json; charset=utf-8';

                  // Send data to backend
                  try {
                    final response = await dio.post(
                      widget.formSubmitUrl,
                      data: formData,
                    );

                    // Handle successful response
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Support request submitted successfully!'),
                        ),
                      );
                    } else {
                      // Handle error responses (optional)
                      print('Error submitting form: ${response.statusCode}');
                      print(
                          '${response.data}'); // Display error message from server (if available)
                    }
                  } catch (error) {
                    // Handle general network errors
                    print('Error submitting form: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('An error occurred. Please try again later.'),
                      ),
                    );
                  } finally {
                    // Close Dio instance (optional)
                    dio.close();
                  }
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
