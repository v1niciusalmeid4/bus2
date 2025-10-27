class Pageable {
  int size;
  int page;

  Pageable({this.size = 10, this.page = 0});

  next() {
    page++;
  }
}
