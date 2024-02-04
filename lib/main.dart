import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    TempleHistoryScreen(),
    MusicLibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Temple History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Music Library',
          ),
        ],
      ),
    );
  }
}

class TempleHistoryScreen extends StatelessWidget {
  final ItemScrollController itemScrollController = ItemScrollController();
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(languageProvider.selectedLanguage == 'Hindi' ? 'भगवान राम मंदिर' : 'Lord Rama Temple', style: TextStyle(
                color: Colors.black, // Change color to your preferred color
                fontWeight: FontWeight.bold,
              ),),
              background: _buildImageCarousel(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildAnimatedDescription(context, languageProvider),
              _buildDetailsSection(context, languageProvider),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDescription(BuildContext context, LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TyperAnimatedTextKit(
        isRepeatingAnimation: false,
        text: languageProvider.selectedLanguage == 'Hindi'
            ? [
          'भगवान राम मंदिर हिंदू साधुओं की पूजा और भक्ति का स्थल है जो भगवान राम को समर्पित है। '
              'यह हिन्दू सांस्कृतिक में बहुत महत्त्वपूर्ण है और इसे दुनियाभर से यात्री आते हैं। '
              'मंदिर भक्ति और आर्थिक सहारा के रूप में खड़ा है और अपनी दिव्य आभा और वास्तुकला से भक्तों को आकर्षित करता है।',
          'मंदिर में राम भगवान की मूर्ति को कीमती पत्थरों से बनाया गया है और इसे जटिल रूप से नकारात्मक बनाया गया है, '
              'जो दैवी प्रतिष्ठा की प्रतिष्ठा को प्रतिष्ठित करता है। भक्त आशीर्वाद प्राप्त करने और मूर्ति से आत्मा के साथ जुड़ने के लिए मंदिर की सहज ऊर्जा के साथ मंदिर में यात्रा करते हैं।',
          'मंदिर वर्षभर विभिन्न धार्मिक कार्यक्रम, त्योहार और घटनाएँ आयोजित करता है, जो समुदाय को समर्पण में एकजुट करता है। यह सांस्कृतिक और धार्मिक गतिविधियों का एक केंद्र है, जो अनुयायियों के बीच एकता और भक्ति की भावना को बढ़ावा देता है।',
        ]
            : [
          'The Lord Rama Temple is a sacred place of worship dedicated to Lord Rama. '
              'It holds immense significance in Hindu culture and is visited by pilgrims '
              'from all around the world. The temple stands as a symbol of devotion and '
              'spirituality, attracting devotees with its divine aura and architectural beauty.',
          'The idol of Lord Rama in the temple is made of precious stones and is intricately carved, representing '
              'the divine presence of the deity. Devotees visit the temple to seek blessings and connect with the '
              'spiritual energy that radiates from the idol.',
          'The temple conducts various religious ceremonies, festivals, and events throughout the year, bringing '
              'together the community in celebration. It serves as a hub of cultural and religious activities, fostering '
              'a sense of unity and devotion among its followers.',
        ],
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(languageProvider.selectedLanguage == 'Hindi' ? 'मंदिर विवरण' : 'Temple Details'),
          SizedBox(height: 16.0),
          _buildSectionTitle(languageProvider.selectedLanguage == 'Hindi' ? 'राम भगवान की मूर्ति' : 'Lord Rama Idol'),
          GestureDetector(
            onTap: () {
              _showIdolDetails(context, languageProvider);
            },
            child: Hero(
              tag: 'idol_image',
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/idol_photo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          _buildLanguageSwitcher(context),
          SizedBox(height: 16.0),
          _buildVoiceButton(languageProvider),
          SizedBox(height: 16.0),
          _buildMandirWahiBanayenge(context, languageProvider),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(languageProvider.selectedLanguage == 'Hindi' ? 'भाषा का चयन करें:' : 'Select Language:'),
        DropdownButton<String>(
          value: languageProvider.selectedLanguage,
          onChanged: (String? newValue) {
            if (newValue != null) {
              languageProvider.setLanguage(newValue);
            }
          },
          items: <String>['English', 'Hindi'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVoiceButton(LanguageProvider languageProvider) {
    return ElevatedButton(
      onPressed: () {
        _speakText(languageProvider);
      },
      child: Text(languageProvider.selectedLanguage == 'Hindi' ? 'आउट लाउड पढ़ें' : 'Read Aloud'),
    );
  }

  Widget _buildMandirWahiBanayenge(BuildContext context, LanguageProvider languageProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(languageProvider.selectedLanguage == 'Hindi' ? 'मंदिर वही बनाएंगे' : 'Mandir Wahi Banayenge'),
        SizedBox(height: 16.0),
        Text(
          languageProvider.selectedLanguage == 'Hindi'
              ? 'मंदिर वही बनयेंगे एक हिंदी अभिव्यक्ति है, और यह राम जन्मभूमि आंदोलन और राम मंदिर के संबंध में सबसे लोकप्रिय नारों में से एक बन गया है। इसे 1985–86 के आस-पास इस्तेमाल किया गया था, और इसे 1990 के दशक में पॉपुलर किया गया था।'
              : 'Mandir Wahi Banayenge is a Hindi expression and has become one of the most popular slogans concerning the Ram Janmabhoomi movement and Ram Mandir. It has been used as early as 1985–86, was popularised in the 1990s, and has several variations.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8.0),
        Text(
          languageProvider.selectedLanguage == 'Hindi'
              ? 'यह आशा का प्रतीक है और इसने उत्सवों का हिस्सा बन गया है, और यह मजाक, चुटकुले और मीमों का एक हिस्सा भी बन गया है।'
              : 'It has been a symbol of hope and it has become a part of festivities, and has also become a part of stand-up comedy, jokes and memes.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8.0),
        Text(
          languageProvider.selectedLanguage == 'Hindi'
              ? '2019 में, इस नारे का संसद में इस्तेमाल किया गया था, और इसे मीडिया हाउसेज ने भी इस्तेमाल किया है।'
              : 'In 2019, the slogan was used in the Parliament of India, and it has also been used by media houses.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8.0),
        Text(
          languageProvider.selectedLanguage == 'Hindi'
              ? 'इस नारे के कई संस्करण और अनुकरण शामिल हैं, जैसे कि लाल कृष्ण आडवाणी द्वारा इस्तेमाल किया गया एक संस्करण: "सौगंध राम की खात-ए हैं; हम मंदिर वहीं बनाएंगे"।'
              : 'There are variations of the slogan such as one used by Lal Krishna Advani: "Saugandh Ram ki Khat-e hain; Hum Mandir Wahin Banayegein".',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Future<void> _speakText(LanguageProvider languageProvider) async {
    String languageCode = languageProvider.selectedLanguage == 'Hindi' ? 'hi-IN' : 'en-US';

    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1.0);

    String textToSpeak = languageProvider.selectedLanguage == 'Hindi'
        ? 'आपका हिंदी या अंग्रेजी पाठ यहाँ'
        : 'Your Hindi or English Text Here';

    await flutterTts.speak(textToSpeak);
  }

  void _showIdolDetails(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(languageProvider.selectedLanguage == 'Hindi' ? 'राम भगवान की मूर्ति' : 'Lord Rama Idol'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageProvider.selectedLanguage == 'Hindi'
                    ? 'राम भगवान की मूर्ति मंदिर में स्थित है और यह केवल पूजा के लिए ही नहीं, बल्कि भक्तों को आकर्षित करने के लिए भी है।'
                    : 'The idol of Lord Rama is located in the temple and is not just for worship, but also to attract the devotees.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                languageProvider.selectedLanguage == 'Hindi'
                    ? 'इस मूर्ति को केवल कीमती पत्थरों से बनाया गया है और इसे जटिल रूप से नकारात्मक बनाया गया है, जो दैवी प्रतिष्ठा की प्रतिष्ठा को प्रतिष्ठित करता है।'
                    : 'This idol is made of precious stones and is intricately carved, representing the divine presence of the deity.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                languageProvider.selectedLanguage == 'Hindi'
                    ? 'भक्त आशीर्वाद प्राप्त करने और मूर्ति से आत्मा के साथ जुड़ने के लिए मंदिर में यात्रा करते हैं।'
                    : 'Devotees visit the temple to seek blessings and connect with the spiritual energy that radiates from the idol.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(languageProvider.selectedLanguage == 'Hindi' ? 'बंद करें' : 'Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider(
      items: [
        Image.asset('assets/images/temple1.jpg', fit: BoxFit.cover),
        Image.asset('assets/images/temple2.jpg', fit: BoxFit.cover),
        Image.asset('assets/images/temple3.jpg', fit: BoxFit.cover),
      ],
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          // Handle page change
        },
      ),
    );
  }
}

class MusicLibraryScreen extends StatefulWidget {
  @override
  _MusicLibraryScreenState createState() => _MusicLibraryScreenState();
}

class _MusicLibraryScreenState extends State<MusicLibraryScreen> {
  final List<String> lordRamaSongs = [
    'Song 1 - Bhajan',
    'Song 2 - Aarti',
    'Song 3 - Mantra',
    // Add more songs as needed
  ];

  final List<String> audioFileNames = [
    'assets/audio/ram_bhajan.mp3',
    'assets/audio/aarti.mp3',
    'assets/audio/matra.mp3',
    // Add more audio file names as needed
  ];

  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  int currentSongIndex = 0;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    await player.setAudioSource(
      ConcatenatingAudioSource(
        children: audioFileNames.map((fileName) {
          return AudioSource.uri(Uri.parse('asset:///$fileName'));
        }).toList(),
      ),
    );

    player.currentIndexStream.listen((index) {
      setState(() {
        currentSongIndex = index!;
      });
    });

    player.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    player.durationStream.listen((duration) {
      setState(() {
        totalDuration = duration!;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.selectedLanguage == 'Hindi' ? 'संगीत पुस्तकालय' : 'Music Library'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              languageProvider.selectedLanguage == 'Hindi'
                  ? 'भगवान राम के लिए संगीत सूची'
                  : 'Music List for Lord Rama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemCount: lordRamaSongs.length,
              itemBuilder: (context, index) {
                return _buildSongItem(context, index, languageProvider);
              },
            ),
          ),
          _buildPlayerControls(context),
        ],
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, int index, LanguageProvider languageProvider) {
    return ListTile(
      title: Text(lordRamaSongs[index]),
      onTap: () {
        _playSong(index);
      },
    );
  }

  Widget _buildPlayerControls(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          Slider(
            value: currentPosition.inSeconds.toDouble(),
            min: 0.0,
            max: totalDuration.inSeconds.toDouble(),
            onChanged: (value) {
              player.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(currentPosition)),
                Text(_formatDuration(totalDuration)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  player.seekToPrevious();
                },
              ),
              IconButton(
                icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                onPressed: () {
                  if (isPlaying) {
                    player.pause();
                  } else {
                    player.play();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  player.seekToNext();
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareSong(context);
            },
          ),
        ],
      ),
    );
  }

  void _playSong(int index) {
    player.setClip(start: Duration.zero, end: null);
    player.seek(Duration.zero, index: index);
    player.play();
    setState(() {
      isPlaying = true;
    });
  }

  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _shareSong(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    String message = languageProvider.selectedLanguage == 'Hindi'
        ? 'आपको इस भजन को सुनना चाहिए: ${lordRamaSongs[currentSongIndex]}'
        : 'You should listen to this song: ${lordRamaSongs[currentSongIndex]}';

    Share.share(message);
  }
}
