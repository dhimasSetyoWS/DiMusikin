import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE7E1),
      appBar: AppBar(
        backgroundColor: const Color(0xff3F4A2C),
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffF5EFE4),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Moh. Faturrahman",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3F4A2C),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "@dimusikin_user",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              buildMenu(Icons.workspace_premium, "Berlangganan Premium"),

              buildMenu(Icons.person_outline, "Informasi Akun"),

              buildMenu(Icons.notifications_none, "Notifikasi"),

              buildMenu(Icons.report_problem_outlined, "Report System"),

              buildMenu(Icons.settings_outlined, "Pengaturan"),

              buildMenu(Icons.help_outline, "Bantuan"),

              buildMenu(Icons.logout, "Keluar"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenu(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xffF5EFE4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffD9C7A7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xff3F4A2C)),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff3F4A2C),
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black45),
        ],
      ),
    );
  }
}
