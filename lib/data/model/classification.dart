enum Classification { ok, refer, error, unprocessed, any }

Classification toClassification(String? classification) {
  if (classification == null) {
    return Classification.unprocessed;
  }
  switch (classification) {
    case 'unprocessed':
      return Classification.unprocessed;
    case '':
      return Classification.unprocessed;
    case 'error':
      return Classification.error;
    case 'refer':
      return Classification.refer;
    case 'abnormal':
      return Classification.refer;
    case 'ok':
      return Classification.ok;
    case 'unusable':
      return Classification.error;
    default:
      return Classification.any;
  }
}

String fromClassification(Classification? classification) {
  if (classification == null) {
    return 'Invalid Status';
  }
  switch (classification) {
    case Classification.unprocessed:
      return 'unprocessed';
    case Classification.error:
      return 'error';
    case Classification.refer:
      return 'refer';
    case Classification.ok:
      return 'ok';
    case Classification.any:
      return 'all';
  }
}



