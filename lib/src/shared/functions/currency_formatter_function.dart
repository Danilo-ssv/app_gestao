class CurrencyFormatterFunction {
  static String _filterZeros(String value) {
    bool endZeros = false;
    String returnValue = '';

    for (int index = 0; index < value.length; index++) {
      if (endZeros) {
        returnValue += value[index];
        continue;
      }

      if (value[index] != '0') {
        endZeros = true;
        returnValue += value[index];
      }
    }

    return returnValue;
  }

  static String _formatValue(String value) {
    final List<String> newValue = [];

    final splitted = value.split('').reversed.toList();

    for (int index = 1; index <= splitted.length; index++) {
      if (index == 3) {
        newValue.add('${splitted[index - 1]},');
      } else if ((index - 3) % 3 == 0) {
        newValue.add('${splitted[index - 1]}.');
      } else {
        newValue.add(splitted[index - 1]);
      }
    }
    return newValue.reversed.join();
  }

  static String format(String value, {bool showSymbol = false}) {
    final nonFormattedValue = _filterZeros(value.replaceAll('.', '').replaceAll(',', ''));
    final formattedValue = _formatValue(nonFormattedValue);
    String firstZeros = '';
    if (formattedValue.isEmpty) {
      firstZeros = '0,00';
    }
    if (formattedValue.length == 1) {
      firstZeros = '0,0';
    }
    if (formattedValue.length == 2) {
      firstZeros = '0,';
    }
    if(showSymbol) return 'R\$ $firstZeros$formattedValue';
    return '$firstZeros$formattedValue';
  }
}
