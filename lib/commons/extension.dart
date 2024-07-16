//merubah huruf kecil (lower) ke huruf kapital di huruf pertama
extension StringExtension on String {
 String get capital => this[0].toUpperCase()+substring(1);
 String get capitalize => split(' ').map((word) => word.capital).join(' '); //jika lebih dari satu kata
}