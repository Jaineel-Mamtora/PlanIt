enum Status {
  Pending,
  Complete,
}

Map<int, String> statusMap = {
  0: "Pending",
  1: "Complete",
};

String getStatusString(int index) {
  return statusMap[index];
}

int getStatusIndex(String status) {
  int index = statusMap.keys
      .firstWhere((k) => statusMap[k] == status, orElse: () => null);
  return index;
}
