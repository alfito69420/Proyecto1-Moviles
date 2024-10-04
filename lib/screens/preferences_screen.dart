import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/global_vales.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _loadSelectedFont();  // Cargar la fuente al iniciar la pantalla
  }

  String? selectedFont = 'Arimo';

  // Función para actualizar el tema
  void updateFont(String? newFont) {
    setState(() {
      selectedFont = newFont;
    });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return [
      const DropdownMenuItem(
        child: Text(
          "Arimo",
          style: TextStyle(fontFamily: 'Arimo'),
        ),
        value: "Arimo", // Cambia el valor a la familia de fuente
      ),
      const DropdownMenuItem(
        child: Text("Timos", style: TextStyle(fontFamily: 'Tinos')),
        value: "Tinos",
      ),
      const DropdownMenuItem(
        child: Text("Courier Prime",
            style: TextStyle(fontFamily: 'Courier Prime')),
        value: "Courier Prime",
      ),
    ];
  }

  // Guardar la fuente seleccionada en SharedPreferences
  Future<void> _saveSelectedFont(String font) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
  }

  // Cargar la fuente seleccionada desde SharedPreferences
  Future<void> _loadSelectedFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? font = prefs.getString('selectedFont');

    if (font != null) {
      setState(() {
        selectedValue = font;
        GlobalValues.selectedFontFamily.value = font;  // Actualiza también el ValueNotifier global
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Lottie.asset("assets/lottie/choose_preferences.json", width: 300),
            const Text(
              "Escoge el tema que mas te agrade",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            themeButton("Tema Luminoso", Colors.white, Colors.black, ""),
            themeButton("Tema Oscuro", Colors.black, Colors.white, ""),
            themeButton("Tema Personalizado", defaultColorScheme.secondary,
                defaultColorScheme.onSecondary, ""),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Escoge la fuente que mas te agrade",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton(
              value: selectedValue,
              items: dropdownItems,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
                // Actualiza la fuente seleccionada globalmente
                GlobalValues.selectedFontFamily.value = selectedValue!;
                // Guardar la selección en SharedPreferences
                _saveSelectedFont(selectedValue!);
              },
              hint: const Text('Seleccione una fuente.'),
            ),
            const SizedBox(
              height: 90,
            ),
            themeButton("Finalizar Configuracion", defaultColorScheme.primary,
                defaultColorScheme.onPrimary, "/home"),
          ],
        ),
      ),
    );
  }

  ElevatedButton themeButton(
      String tema, Color esquema, Color colorTexto, String? ruta) {
    return ElevatedButton(
        onPressed: () {
          if (ruta!.isNotEmpty) {
            Navigator.pushNamed(context, ruta);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: esquema,
        ),
        child: Text(
          tema,
          style: TextStyle(color: colorTexto),
        ));
  }
}
