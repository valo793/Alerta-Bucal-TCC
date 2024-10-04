import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _loadFirstTimeStatus();
  }

  Future<void> _loadFirstTimeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirstTime = prefs.getBool('isFirstTimePreferences') ?? true;
    });
  }

  Future<void> _setFirstTimeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimePreferences', false);
  }

  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<PreferencesModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferências do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha as suas preferências:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Switch para bloquear ou permitir YouTube
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bloquear YouTube', style: TextStyle(fontSize: 16)),
                Switch(
                  value: preferences.blockYouTube,
                  onChanged: (value) {
                    preferences.setYouTubeBlock(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Switch para bloquear ou permitir TikTok
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bloquear TikTok', style: TextStyle(fontSize: 16)),
                Switch(
                  value: preferences.blockTikTok,
                  onChanged: (value) {
                    preferences.setTikTokBlock(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Botão para confirmar as preferências
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (isFirstTime) {
                    // Se for a primeira vez, redirecionar para a tela de senha
                    await _setFirstTimeStatus();
                    Navigator.pushReplacementNamed(context, '/password');
                  } else {
                    // Se não for a primeira vez, voltar para a página anterior
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar e Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
