class Notes {
  final String notesId;
  final String title;
  final String content;

  Notes({this.notesId, this.content, this.title});

  Map<String, dynamic> toMap() {
    return {
      'notesId': notesId, 
      'title': title, 
      'content': content
    };
  }
}
