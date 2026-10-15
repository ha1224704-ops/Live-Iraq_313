import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() => runApp(LiveIraqApp());

class LiveIraqApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0F0F0F)),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  void _openPlayer(Map match) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(match: match)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onPlay: _openPlayer),
          LiveScreen(onPlay: _openPlayer),
          MatchesScreen(onPlay: _openPlayer),
          FavScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Color(0xFF1E1E1E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFE41E20),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'مباشر'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'المباريات'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// موديل المباراة مع اعلام حقيقية
List<Map> todayMatches = [
  {
    "id": 1,
    "t1": "العراق", "t2": "البحرين",
    "flag1": "https://flagcdn.com/w80/iq.png", "flag2": "https://flagcdn.com/w80/bh.png",
    "time": "16:30", "hour": 16, "minute": 30,
    "league": "كأس العرب", "channel": "beIN المفتوحة",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
  {
    "id": 2,
    "t1": "سالزبورج", "t2": "ميلان",
    "flag1": "https://flagcdn.com/w80/at.png", "flag2": "https://flagcdn.com/w80/it.png",
    "time": "19:45", "hour": 19, "minute": 45,
    "league": "الدوري الأوروبي", "channel": "beIN HD1",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
  {
    "id": 3,
    "t1": "ليون", "t2": "كريستال بالاس",
    "flag1": "https://flagcdn.com/w80/fr.png", "flag2": "https://flagcdn.com/w80/gb-eng.png",
    "time": "19:45", "hour": 19, "minute": 45,
    "league": "الدوري الأوروبي", "channel": "beIN HD1",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
  {
    "id": 4,
    "t1": "كوبس", "t2": "طرابزون سبور",
    "flag1": "https://flagcdn.com/w80/fi.png", "flag2": "https://flagcdn.com/w80/tr.png",
    "time": "19:45", "hour": 19, "minute": 45,
    "league": "دوري المؤتمر - محمد صلاح", "channel": "beIN HD3",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
  {
    "id": 5,
    "t1": "سيلتا فيجو", "t2": "يوفنتوس",
    "flag1": "https://flagcdn.com/w80/es.png", "flag2": "https://flagcdn.com/w80/it.png",
    "time": "22:00", "hour": 22, "minute": 0,
    "league": "الدوري الأوروبي", "channel": "beIN HD1",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
  {
    "id": 6,
    "t1": "الزوراء", "t2": "الكرخ",
    "flag1": "https://flagcdn.com/w80/iq.png", "flag2": "https://flagcdn.com/w80/iq.png",
    "time": "23:15", "hour": 23, "minute": 15,
    "league": "دوري نجوم العراق", "channel": "العراقية الرياضية",
    "url": "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"
  },
];

String getMatchStatus(Map m) {
  final now = DateTime.now();
  final matchTime = DateTime(now.year, now.month, now.day, m["hour"], m["minute"]);
  final diff = now.difference(matchTime).inMinutes;
  if (diff >= -15 && diff <= 120) return "مباشر";
  if (diff < -15) return "لم تبدأ";
  return "انتهت";
}

class HomeScreen extends StatelessWidget {
  final Function(Map) onPlay;
  HomeScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(height: 6, color: Color(0xFFE41E20)),
          Container(height: 32, color: Colors.white, child: Center(child: Text("الله أكبر", style: TextStyle(color: Color(0xFF00A651), fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Amiri')))),
          Container(height: 6, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("لايف عراق", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("LIVE IRAQ - مباريات اليوم ${DateFormat('dd/MM').format(DateTime.now())}", style: TextStyle(color: Colors.grey, fontSize: 11)),
              ]),
              Icon(Icons.search),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: todayMatches.length,
              itemBuilder: (c, i) {
                var m = todayMatches[i];
                String status = getMatchStatus(m);
                bool isLive = status == "مباشر";
                return GestureDetector(
                  onTap: () => onPlay(m),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16), border: isLive? Border.all(color: Colors.red.withOpacity(0.5)): null),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text("${m["league"]} - ${m["channel"]}", style: TextStyle(color: Colors.grey, fontSize: 11)),
                          Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: isLive? Colors.red : status=="لم تبدأ"? Colors.orange: Colors.grey, borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(fontSize: 11, color: Colors.white))),
                        ]),
                        SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(m["flag1"], width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,__,___)=>CircleAvatar(child: Text(m["t1"][0])))), SizedBox(width: 8), Text(m["t1"], style: TextStyle(fontWeight: FontWeight.bold))]),
                          Text("VS", style: TextStyle(color: Colors.grey)),
                          Row(children: [Text(m["t2"], style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 8), ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(m["flag2"], width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (_,__,___)=>CircleAvatar(child: Text(m["t2"][0]))))]),
                        ]),
                        SizedBox(height: 10),
                        Row(children: [Icon(Icons.access_time, size: 14, color: isLive? Colors.red: Colors.grey), SizedBox(width: 4), Text("${m["time"]} بتوقيت بغداد - ${isLive? "اضغط للمشاهدة الان":"المباراة $status"}", style: TextStyle(color: isLive? Colors.red: Colors.grey, fontSize: 12, fontWeight: isLive? FontWeight.bold: FontWeight.normal))]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final Map match;
  PlayerScreen({required this.match});
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _commentator = "فراس عوض";
  String _quality = "تلقائي";
  List<String> commentators = ["فراس عوض", "عصام الشوالي", "حفيظ الدراجي"];
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.match["url"])
      ..initialize().then((_) {
        setState(() => _isLoading = false);
        _controller.play();
      }).catchError((e){
        setState(() {_isLoading=false; _hasError=true;});
      });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Color(0xFF1E1E1E), title: Text("${widget.match["t1"]} vs ${widget.match["t2"]}", style: TextStyle(fontSize: 14))),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: _isLoading? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: Colors.red), SizedBox(height: 8), Text("جاري تحميل البث...")] )):
            _hasError? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.error, color: Colors.red, size: 40), Text("فشل تحميل البث، تأكد من النت"), ElevatedButton(onPressed: (){setState((){_isLoading=true; _hasError=false;}); _controller.initialize().then((_)=>_controller.play());}, child: Text("اعادة المحاولة"))])) :
            Stack(
              children: [
                VideoPlayer(_controller),
                Positioned(bottom: 8, left: 8, right: 8, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)), child: Text("🎙️ $_commentator | $_quality", style: TextStyle(fontSize: 10))),
                  IconButton(icon: Icon(_controller.value.isPlaying? Icons.pause: Icons.play_arrow, color: Colors.white), onPressed: ()=>setState(()=> _controller.value.isPlaying? _controller.pause(): _controller.play())),
                ])),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(12), child: Row(children: [Image.network(widget.match["flag1"], width: 24, height: 24), SizedBox(width: 6), Text(widget.match["t1"]), Spacer(), Text("${widget.match["time"]}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), Spacer(), Text(widget.match["t2"]), SizedBox(width: 6), Image.network(widget.match["flag2"], width: 24, height: 24)])),
          Divider(color: Color(0xFF1E1E1E)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Row(children: [Icon(Icons.mic, color: Colors.red, size: 18), Text("  اختر المعلق:", style: TextStyle(fontWeight: FontWeight.bold))])),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: commentators.map((name){
            bool sel = name==_commentator;
            return GestureDetector(onTap: ()=>setState(()=>_commentator=name), child: Container(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: sel? Colors.red: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)), child: Text(name, style: TextStyle(color: sel? Colors.white: Colors.grey, fontSize: 13))));
          }).toList()),
          SizedBox(height: 12),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Row(children: [Icon(Icons.hd, color: Colors.red, size: 18), Text("  الجودة:"), SizedBox(width: 10), DropdownButton<String>(value: _quality, dropdownColor: Color(0xFF1E1E1E), items: ["تلقائي","1080p","720p","480p","360p"].map((q)=>DropdownMenuItem(value: q, child: Text(q))).toList(), onChanged: (v)=>setState(()=>_quality=v!)) ])),
        ],
      ),
    );
  }
}

class LiveScreen extends StatelessWidget {
  final Function(Map) onPlay;
  LiveScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) {
    var live = todayMatches.where((m)=>getMatchStatus(m)=="مباشر").toList();
    if(live.isEmpty) return Center(child: Text("لا توجد مباريات مباشرة الان\nالمباريات القادمة الساعة 19:45", textAlign: TextAlign.center));
    return ListView.builder(padding: EdgeInsets.all(12), itemCount: live.length, itemBuilder: (c,i){ var m=live[i]; return ListTile(leading: Image.network(m["flag1"], width: 30), title: Text("${m["t1"]} vs ${m["t2"]}"), subtitle: Text(m["league"]), trailing: ElevatedButton(onPressed: ()=>onPlay(m), child: Text("مشاهدة")), onTap: ()=>onPlay(m));});
  }
}
class MatchesScreen extends StatelessWidget {
  final Function(Map) onPlay;
  MatchesScreen({required this.onPlay});
  @override
  Widget build(BuildContext context) => HomeScreen(onPlay: onPlay);
}
class FavScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("المفضلة - قريبا"));
}

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}
class _AccountScreenState extends State<AccountScreen> {
  String? _userName;
  String? _userEmail;
  bool _isLogged = false;
  bool _dataSaver = false;
  String _quality = "تلقائي";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }
  _loadUser() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLogged = prefs.getBool("isLogged")??false;
      _userName = prefs.getString("userName");
      _userEmail = prefs.getString("userEmail");
      _dataSaver = prefs.getBool("dataSaver")??false;
      _quality = prefs.getString("quality")??"تلقائي";
    });
  }
  _login(String provider) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogged", true);
    await prefs.setString("userName", provider=="google"? "مستخدم Google" : "مستخدم Facebook");
    await prefs.setString("userEmail", provider=="google"? "user@gmail.com" : "user@facebook.com");
    _loadUser();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تسجيل الدخول عبر $provider بنجاح"), backgroundColor: Colors.green));
  }
  _logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(16), children: [
      SizedBox(height: 30),
      CircleAvatar(radius: 45, backgroundColor: Color(0xFF1E1E1E), child: Icon(_isLogged? Icons.person: Icons.person_outline, size: 45, color: _isLogged? Colors.red: Colors.grey)),
      SizedBox(height: 12),
      Center(child: Text(_isLogged? _userName! : "زائر", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
      Center(child: Text(_isLogged? _userEmail! : "سجل دخول لحفظ المفضلة", style: TextStyle(color: Colors.grey, fontSize: 12))),
      SizedBox(height: 20),
      if(!_isLogged) ...[
        ElevatedButton.icon(icon: Icon(Icons.login), label: Text("تسجيل الدخول بـ Google"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), onPressed: ()=>_login("google")),
        SizedBox(height: 8),
        ElevatedButton.icon(icon: Icon(Icons.facebook), label: Text("تسجيل الدخول بـ Facebook"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1877F2)), onPressed: ()=>_login("facebook")),
      ] else ...[
        ElevatedButton.icon(icon: Icon(Icons.logout), label: Text("تسجيل خروج"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: _logout),
      ],
      Divider(height: 30),
      ListTile(leading: Icon(Icons.hd), title: Text("جودة الفيديو الافتراضية"), trailing: DropdownButton<String>(value: _quality, items: ["تلقائي","1080p","720p","480p","360p","144p"].map((q)=>DropdownMenuItem(value: q, child: Text(q, style: TextStyle(fontSize: 12)))).toList(), onChanged: (v) async { var p=await SharedPreferences.getInstance(); await p.setString("quality", v!); setState(()=>_quality=v); })),
      SwitchListTile(title: Text("توفير البيانات"), subtitle: Text("تقليل الجودة تلقائيا اذا النت ضعيف"), value: _dataSaver, activeColor: Colors.red, onChanged: (v) async { var p=await SharedPreferences.getInstance(); await p.setBool("dataSaver", v); setState(()=>_dataSaver=v); }),
      ListTile(leading: Icon(Icons.notifications), title: Text("اشعارات المباريات"), trailing: Switch(value: true, activeColor: Colors.red, onChanged: (v){})),
      ListTile(leading: Icon(Icons.info_outline), title: Text("لايف عراق v1.1"), subtitle: Text("البصرة - العراق - وقت المباريات بتوقيت بغداد")),
    ]);
  }
}