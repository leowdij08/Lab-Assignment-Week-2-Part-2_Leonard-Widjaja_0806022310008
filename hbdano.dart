import 'dart:async';
import 'dart:io';
import 'dart:math';

final random = Random();

const String hapusLayar = "\x1B[2J\x1B[H";
const String sembunyiKursor = "\x1B[?25l";
const String tampilKursor = "\x1B[?25h";

final List<String> warna = [
  "\x1B[48;5;196m", "\x1B[48;5;202m", "\x1B[48;5;220m", "\x1B[48;5;82m",
  "\x1B[48;5;45m", "\x1B[48;5;51m", "\x1B[48;5;201m", "\x1B[48;5;207m",
  "\x1B[48;5;93m", "\x1B[48;5;214m", "\x1B[48;5;33m", "\x1B[48;5;118m"
];

String gerakkanKursor(int baris, int kolom) => "\x1B[${baris};${kolom}H";

String dapatkanWarnaAcak() => warna[random.nextInt(warna.length)];

Future<void> tampilkanKembangApi(int i, int lebarTerminal, int tinggiTerminal) async {
  stdout.write(sembunyiKursor);

  int kolom = i == 0 ? lebarTerminal ~/ 2 : random.nextInt(lebarTerminal - 4) + 2;
  int baris = tinggiTerminal ~/ 2;

  await animasiPeluncuran(baris, kolom, tinggiTerminal - 1);
  await animasiPecahan(baris, kolom);

  stdout.write(tampilKursor);
}

Future<void> animasiPeluncuran(int barisAkhir, int kolom, int barisMulai) async {
  for (int baris = barisMulai; baris >= barisAkhir; baris--) {
    stdout.write(hapusLayar);
    stdout.write(gerakkanKursor(baris, kolom));
    stdout.write("|");
    await Future.delayed(Duration(milliseconds: 100));
  }
}

Future<void> animasiPecahan(int baris, int kolom) async {
  var warnaAcak = dapatkanWarnaAcak();

  ubahWarnaLayar(warnaAcak);
  stdout.write(gerakkanKursor(baris, kolom));
  stdout.write("${warnaAcak}o\x1B[0m");
  await Future.delayed(Duration(milliseconds: 100));

  tampilkanPolaLingkaranBesar(baris, kolom, warnaAcak);
  await Future.delayed(Duration(milliseconds: 100));

  ubahWarnaLayar("\x1B[40m");
  stdout.write(hapusLayar);
}

void ubahWarnaLayar(String warna) {
  stdout.write("$warna\x1B[2J\x1B[H");
}

void tampilkanPolaLingkaranBesar(int baris, int kolom, String warna) {
  stdout.write(gerakkanKursor(baris, kolom));
  stdout.write("${warna}o\x1B[0m");

  for (int i = 1; i <= 3; i++) {
    stdout.write(gerakkanKursor(baris - i, kolom));
    stdout.write("${warna}o\x1B[0m");
    stdout.write(gerakkanKursor(baris + i, kolom));
    stdout.write("${warna}o\x1B[0m");
    stdout.write(gerakkanKursor(baris, kolom - i));
    stdout.write("${warna}o\x1B[0m");
    stdout.write(gerakkanKursor(baris, kolom + i));
    stdout.write("${warna}o\x1B[0m");

    for (int j = 1; j <= i; j++) {
      stdout.write(gerakkanKursor(baris - i, kolom - j));
      stdout.write("${warna}o\x1B[0m");
      stdout.write(gerakkanKursor(baris - i, kolom + j));
      stdout.write("${warna}o\x1B[0m");
      stdout.write(gerakkanKursor(baris + i, kolom - j));
      stdout.write("${warna}o\x1B[0m");
      stdout.write(gerakkanKursor(baris + i, kolom + j));
      stdout.write("${warna}o\x1B[0m");
    }
  }
}

Future<void> tampilkanHBDANO(int lebarTerminal, int tinggiTerminal) async {
  stdout.write(hapusLayar);

  List<String> hbdano = [
    "H     H  BBBBBB   DDDDD         A     N     N  OOOOOO",
    "H     H  B     B  D    D       A A    N N   N  O    O",
    "HHHHHHH  BBBBBB   D     D     AAAAA   N  N  N  O    O",
    "H     H  B     B  D    D     A     A  N   N N  O    O",
    "H     H  BBBBBB   DDDDD     A       A N     N  OOOOOO"
  ];

  int barisMulai = tinggiTerminal - hbdano.length - 1;
  int kolomMulai = (lebarTerminal ~/ 2) - (hbdano[0].length ~/ 2);

  for (int baris = barisMulai; baris >= 0; baris--) {
    stdout.write(hapusLayar);
    for (int i = 0; i < hbdano.length; i++) {
      int barisSaatIni = baris + i;
      if (barisSaatIni >= 0 && barisSaatIni < tinggiTerminal) {
        stdout.write(gerakkanKursor(barisSaatIni, kolomMulai));
        stdout.writeln(hbdano[i]);
      }
    }
    await Future.delayed(Duration(milliseconds: 100));
  }

  stdout.write(hapusLayar);
}

void main() async {
  stdout.write("Masukkan jumlah kembang api: ");
  int? jumlahKembangApi = int.parse(stdin.readLineSync()!);

  stdout.write(hapusLayar);
  int tinggiTerminal = stdout.terminalLines;
  int lebarTerminal = stdout.terminalColumns;

  for (int i = 0; i < jumlahKembangApi; i++) {
    await tampilkanKembangApi(i, lebarTerminal, tinggiTerminal);
  }

  await tampilkanHBDANO(lebarTerminal, tinggiTerminal);
  stdout.write(tampilKursor);
}
