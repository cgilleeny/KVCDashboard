import './eyepair.dart';

class EyepairPage {
  final List<EyePair> eyepairs;
  final String? nextPartitionKey;
  final String? nextRowKey;
  int pageIndex = 0;

  bool get hasNextPage {
    return nextPartitionKey != null && nextRowKey != null;
  }

  EyepairPage(this.eyepairs,
      {this.nextPartitionKey, this.nextRowKey});
}

class AzurePage {
  String partitionKey;
  String rowKey;

  AzurePage(this.partitionKey, this.rowKey);
}
