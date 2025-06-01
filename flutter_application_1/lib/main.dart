import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'savings_page.dart';
import 'lessons_page.dart';
import 'tasks_page.dart';
import 'models.dart';

const kPashaGreen = Color(0xFF198754);
const kPashaRed = Color(0xFFDA2032);
const kPashaBackground = Color(0xFFF7F9F9);

void main() => runApp(const BunnyBankApp());

class BunnyBankApp extends StatelessWidget {
  const BunnyBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _WalletPage(),
      const SavingsPage(),
      const LessonsPage(),
      const TasksPage(),
    ];

    return Scaffold(
      backgroundColor: kPashaBackground,
      body: pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPashaGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Savings'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Tasks'),
        ],
      ),
    );
  }
}

// --------------------------  WALLET  ---------------------------------
class _WalletPage extends StatefulWidget {
  const _WalletPage({super.key});

  @override
  State<_WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<_WalletPage> {
  WalletData? _wallet;
  bool _loading = true;
  String? _error;

  List<Transaction> _history = [];
  bool _historyLoading = true;
  String? _historyError;

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
    fetchHistory();
  }

  Future<void> fetchWalletBalance() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final url = Uri.parse('http://192.168.53.49:3000/api/wallet-balance');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _wallet = WalletData.fromJson(data);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "API Error: ${res.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to connect to API";
        _loading = false;
      });
    }
  }

  Future<void> fetchHistory() async {
    setState(() {
      _historyLoading = true;
      _historyError = null;
    });
    try {
      final url = Uri.parse('http://192.168.53.49:3000/api/transactions');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        setState(() {
          _history = list.map((e) => Transaction.fromJson(e)).toList();
          _historyLoading = false;
        });
      } else {
        setState(() {
          _historyError = "API Error: ${res.statusCode}";
          _historyLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _historyError = "Failed to connect to API";
        _historyLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top bar
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/logo.jpg'),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Pasha Kids',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: kPashaGreen,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 28,
                    color: kPashaGreen,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No notifications')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu, size: 28, color: kPashaGreen),
                  onPressed: () => _showMenu(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: kPashaGreen,
              ),
            ),
            const SizedBox(height: 110),

            // bunny + bubble + card
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -105,
                  left: 8,
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Image.asset('assets/bunny.png'),
                  ),
                ),
                Positioned(
                  top: -86,
                  left: 150,
                  child: const SpeechBubble(
                    "Hi, I'm Bunny.\nYour friend and helper",
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(50, 32, 24, 24),
                  decoration: BoxDecoration(
                    color: kPashaGreen,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      else if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        )
                      else
                        Text(
                          '${_wallet?.balance ?? '-'} ₼',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your daily limit:',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${_wallet?.todaySpent ?? '-'} ₼',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value:
                                  (_wallet != null && _wallet!.dailyLimit > 0)
                                  ? _wallet!.todaySpent / _wallet!.dailyLimit
                                  : 0,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                kPashaRed,
                              ),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_wallet?.dailyLimit ?? '-'} ₼',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _wallet?.cardNumber ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // HISTORY SECTION
            const Text(
              'History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: kPashaGreen,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _historyLoading
                  ? const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Center(
                        child: CircularProgressIndicator(color: kPashaGreen),
                      ),
                    )
                  : _historyError != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _historyError!,
                        style: const TextStyle(
                          color: kPashaRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : (_history.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(22),
                            child: Center(
                              child: Text(
                                'No history yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(18),
                            itemCount: _history.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final tx = _history[i];
                              return _HistoryItem(
                                icon: tx.icon,
                                label: tx.label,
                                amount:
                                    '${tx.type == 'WITHDRAW' || tx.amount < 0 ? '-' : '+'}${tx.amount.abs()} ₼',
                                color: tx.type == 'WITHDRAW' || tx.amount < 0
                                    ? kPashaRed
                                    : kPashaGreen,
                                date: tx.displayDate,
                              );
                            },
                          )),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline, color: kPashaGreen),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              _showProfile(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: kPashaGreen),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Settings')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: kPashaGreen),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Help')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: kPashaRed),
            title: const Text('Log out'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logged out')));
            },
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: kPashaGreen.withOpacity(0.13),
                child: ClipOval(
                  child: Image.asset(
                    'assets/bunny.png',
                    width: 66,
                    height: 66,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Nazrin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: kPashaGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Pasha Kids App",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const Divider(height: 32, thickness: 1),
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: kPashaGreen,
                ),
                title: const Text("Current Balance"),
                trailing: Text(
                  "${_wallet?.balance ?? '-'} ₼",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: const Text("Rewards"),
                trailing: const Text("5"),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPashaGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(140, 44),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile editing coming soon!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------- HISTORY ITEM ---------------------
class _HistoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;
  final String date;
  const _HistoryItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CloudClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        color: kPashaRed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _CloudClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    const r = 18.0, tail = 18.0;
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, s.width, s.height),
          const Radius.circular(r),
        ),
      )
      ..moveTo(r, s.height)
      ..lineTo(r + tail / 2, s.height + tail)
      ..lineTo(r + tail, s.height)
      ..close();
  }

  @override
  bool shouldReclip(_) => false;
}
